//
//  QuestEngine+PreferenceBoardRefresh.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func refreshAvailableDailyQuestsForPreferences() {
        let context = persistence.container.viewContext
        guard let gameDay = gameDayBounds() else { return }
        let quests = fetchQuestInstances(
            context: context,
            start: gameDay.start,
            end: gameDay.end,
            isSideQuest: false
        )
        guard !quests.contains(where: { $0.state == "active" || $0.state == "locked" }) else { return }

        for quest in quests where quest.state == "available" {
            context.delete(quest)
        }
        guard let dailyGenerationContext = prepareDailyQuestGeneration(
            context: context,
            gameDay: gameDay
        ) else {
            return
        }
        let preferenceFingerprint = QuestFilterPreferencesFingerprint.make(
            for: QuestFilterPreferences.load()
        )
        let preferenceGenerationContext = DailyQuestGenerationContextFactory.make(
            ownerID: accountScopeProvider.activeScope.writeOwnerID,
            gameDayStart: gameDay.start,
            slots: dailyGenerationContext.slots,
            calendar: .current,
            seedVariant: "preferences|\(preferenceFingerprint)"
        )
        let userStats = fetchOrCreateUserStats(context: context)
        let generatedCount = createRandomQuests(
            context: context,
            count: preferenceGenerationContext.slots.count,
            isSideQuest: false,
            userLevel: Int(userStats.level),
            dailyGenerationContext: preferenceGenerationContext
        )
        analytics.track(event: "quest_generated", properties: QuestAnalyticsProperties.generated(
            count: generatedCount,
            userStats: userStats,
            isPro: storeKit.isPro,
            source: "quest_preferences",
            isFirstGeneration: false
        ))
        saveContext()
    }
}
