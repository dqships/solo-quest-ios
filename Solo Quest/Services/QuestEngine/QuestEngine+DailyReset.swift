//
//  QuestEngine+DailyReset.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension QuestEngine {
    @discardableResult
    func checkDailyReset() async -> DailyResetOutcome {
        guard persistence.isReadyForDailyReset else { return .noReset }
        let entitlementDecision = await storeKit.refreshCustomerInfoForPenalty()
        guard entitlementDecision != .unresolved else {
            // Do not advance the generation marker or destroy prior quests when
            // entitlement verification is unavailable. The next successful
            // refresh will reconcile every missed closed game day exactly once.
            return .noReset
        }

        let context = persistence.container.viewContext
        let userStats = fetchOrCreateUserStats(context: context)
        guard let currentGameDay = gameDayBounds() else { return .noReset }

        if let lastDate = userStats.lastDailyGenerationDate {
            guard let lastGameDay = gameDayBounds(containing: lastDate) else { return .noReset }
            if lastGameDay.start == currentGameDay.start {
                if reconcileCurrentDailyQuestQuota(context: context) {
                    do {
                        try context.save()
                    } catch {
                        print("❌ QuestEngine: Failed to save context after daily quota reconciliation: \(error)")
                    }
                }
                return .noReset
            }
        }

        print("🔄 QuestEngine: Triggering Daily Reset")
        let outcome = generateDailyQuests(
            context: context,
            userStats: userStats,
            entitlementDecision: entitlementDecision
        )

        do {
            try context.save()
        } catch {
            print("❌ QuestEngine: Failed to save context after daily reset: \(error)")
        }

        return outcome
    }

    func updateQuestStates() {
        let context = persistence.container.viewContext
        let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        request.predicate = accountScopedPredicate(NSPredicate(format: "state == %@ OR state == %@", "locked", "active"), scope: accountScopeProvider.activeScope)

        do {
            let quests = try context.fetch(request)
            let now = Date()
            var changed = false

            for quest in quests {
                if let expiry = quest.expiryTime, now >= expiry {
                    failQuest(quest)
                    continue
                }

                if quest.state == "locked", let activation = quest.activationTime, now >= activation {
                    quest.state = "active"
                    changed = true
                }
            }

            if changed {
                try context.save()
            }
        } catch {
            print("❌ QuestEngine: Failed to update quest states: \(error)")
        }
    }

    @discardableResult
    func generateDailyQuests(
        context: NSManagedObjectContext,
        userStats: UserStats,
        entitlementDecision: PenaltyEntitlementDecision
    ) -> DailyResetOutcome {
        guard gameData != nil, let gameDay = gameDayBounds() else { return .noReset }

        let dailySkipPenaltyXP = reconcileMissedGameDays(
            context: context,
            userStats: userStats,
            currentGameDay: gameDay,
            entitlementDecision: entitlementDecision
        )

        let cleanupRequest: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        cleanupRequest.predicate = accountScopedPredicate(NSPredicate(
            format: "isSideQuest == NO AND (dateAssigned == nil OR dateAssigned < %@) AND state IN %@",
            gameDay.start as NSDate,
            ["available", "active", "locked"]
        ), scope: accountScopeProvider.activeScope)

        if let oldQuests = try? context.fetch(cleanupRequest) {
            for quest in oldQuests {
                context.delete(quest)
            }
        }

        guard let dailyGenerationContext = prepareDailyQuestGeneration(
            context: context,
            gameDay: gameDay
        ) else {
            return .noReset
        }
        upsertCurrentDailyResetRecord(
            context: context,
            gameDay: gameDay,
            dailyGenerationContext: dailyGenerationContext
        )
        let generatedQuestCount = dailyGenerationContext.slots.count

        if generatedQuestCount > 0 {
            let isFirstGeneration = isFirstQuestGeneration(context: context)
            let actualGeneratedCount = createRandomQuests(
                context: context,
                count: generatedQuestCount,
                isSideQuest: false,
                userLevel: Int(userStats.level),
                dailyGenerationContext: dailyGenerationContext
            )
            analytics.track(event: "quest_generated", properties: QuestAnalyticsProperties.generated(
                count: actualGeneratedCount,
                userStats: userStats,
                isPro: storeKit.isPro,
                source: "daily_reset",
                isFirstGeneration: isFirstGeneration
            ))
        } else {
            reconcileCurrentDailyQuestQuota(context: context)
        }

        userStats.dailyProSideQuestRemaining = 0

        userStats.lastDailyGenerationDate = Date()

        return DailyResetOutcome(didReset: true, dailySkipPenaltyXP: dailySkipPenaltyXP)
    }

    func isSameGameDay(date1: Date, date2: Date) -> Bool {
        guard let firstGameDay = gameDayBounds(containing: date1),
              let secondGameDay = gameDayBounds(containing: date2) else {
            return false
        }
        return firstGameDay.start == secondGameDay.start
    }

}
