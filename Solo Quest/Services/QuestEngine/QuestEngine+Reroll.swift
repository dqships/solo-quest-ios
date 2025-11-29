//
//  QuestEngine+Reroll.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension QuestEngine {
    enum QuestError: Error {
        case insufficientCredits
        case questInProgress
        case dailyLimitReached
        case noSuitableQuests
        case inaccessibleQuest
    }

    func rerollDailyQuests(reason: RerollReason) throws {
        let context = persistence.container.viewContext
        let userStats = fetchOrCreateUserStats(context: context)

        guard let gameDay = gameDayBounds() else {
            return
        }

        let todayQuests = fetchQuestInstances(
            context: context,
            start: gameDay.start,
            end: gameDay.end,
            isSideQuest: false
        )

        if todayQuests.contains(where: { $0.state == "active" || $0.state == "locked" }) {
            throw QuestError.questInProgress
        }

        filterPreferences = QuestFilterPreferences.load()
        let goalStrings = userStats.goals?.split(separator: ",").map {
            String($0).trimmingCharacters(in: .whitespaces)
        } ?? []
        let replacedTemplateIDs = Set(todayQuests.compactMap(\.questTemplateId))
        let feedback = lifecycle.todayRerollFeedback().union([reason])
        let dailySlots = Array(0..<dailyQuestLimit()).compactMap(Int16.init(exactly:))
        let dailyGenerationContext = DailyQuestGenerationContextFactory.make(
            ownerID: accountScopeProvider.activeScope.writeOwnerID,
            gameDayStart: gameDay.start,
            slots: dailySlots,
            calendar: .current,
            seedVariant: "reroll|\(lifecycle.rerollsToday + 1)|\(reason.rawValue)"
        )
        let replacements = selectQuests(
            count: dailyQuestLimit(),
            userLevel: Int(userStats.level),
            preferredStats: getPreferredStats(from: Set(goalStrings)),
            filterPrefs: filterPreferences,
            isNewPlayer: userStats.totalXP == 0,
            excludingTemplateIDs: replacedTemplateIDs,
            rerollFeedbackOverride: feedback,
            dailyGenerationContext: dailyGenerationContext
        )
        guard !replacements.isEmpty else { throw QuestError.noSuitableQuests }

        let protectionActive = newPlayerProtection.isActive()
        if storeKit.isPro || protectionActive {
            print("👑 Used Guild Pass Reroll")
        } else {
            guard userStats.sideQuestCredits > 0 else {
                throw QuestError.insufficientCredits
            }

            userStats.sideQuestCredits -= 1
            print("🪙 Used Reroll Credit (Remaining: \(userStats.sideQuestCredits))")
        }

        for quest in todayQuests {
            context.delete(quest)
        }

        lifecycle.recordReroll(reason: reason)
        for (index, template) in replacements.enumerated() where index < dailyGenerationContext.slots.count {
            createQuestInstance(
                from: template,
                context: context,
                isSideQuest: false,
                dailyGenerationContext: dailyGenerationContext,
                dailySlot: dailyGenerationContext.slots[index]
            )
        }

        let properties: [String: Any] = [
            "source": "quest_list",
            "quest_count": replacements.count,
            "reroll_reason": reason.rawValue,
            "rerolls_today": lifecycle.rerollsToday,
            "rerolls_lifetime": lifecycle.rerollsLifetime,
            "new_user_protection_active": protectionActive,
            "is_pro": storeKit.isPro,
            "user_level": Int(userStats.level),
            "user_rank": userStats.rank ?? "E",
            "user_total_xp": Int(userStats.totalXP),
            "user_current_streak": Int(userStats.currentStreak),
            "active_days_lifetime": lifecycle.activeDaysLifetime,
            "days_since_install": lifecycle.daysSinceInstall()
        ]
        analytics.track(event: "quest_rerolled", properties: properties)

        saveContext()
    }
}
