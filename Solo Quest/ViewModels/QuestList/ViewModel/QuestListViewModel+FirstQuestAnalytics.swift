//
//  QuestListViewModel+FirstQuestAnalytics.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import CoreData
import Foundation

extension QuestListViewModel {
    func trackQuestSeenIfNeeded(stats: UserStats) {
        for quest in dailyQuests where lifecycle.shouldTrackFirstEvent("quest_seen:\(quest.id?.uuidString ?? quest.objectID.uriRepresentation().absoluteString)") {
            analytics.track(event: "quest_seen", properties: QuestAnalyticsProperties.make(
                quest: quest,
                userStats: stats,
                isPro: questEngine.storeKit.isPro,
                isFirstQuest: stats.totalXP == 0,
                source: "quest_list",
                template: quest.questTemplateId.flatMap { questEngine.getTemplate(id: $0) },
                extra: questEngine.retentionAnalyticsProperties(context: persistence.container.viewContext).merging([
                    "matches_all_preferences": quest.questTemplateId.flatMap { questEngine.getTemplate(id: $0) }.map {
                        questEngine.matchesAllPreferences(quest: $0, filterPrefs: questEngine.getFilterPreferences())
                    } ?? false
                ], uniquingKeysWith: { _, new in new })
            ))
        }
    }

    func trackFirstQuestSeenIfNeeded(stats: UserStats) {
        guard stats.totalXP == 0, let quest = dailyQuests.first else { return }
        guard lifecycle.shouldTrackFirstEvent("first_quest_seen") else { return }

        analytics.track(event: "first_quest_seen", properties: QuestAnalyticsProperties.make(
            quest: quest,
            userStats: stats,
            isPro: questEngine.storeKit.isPro,
            isFirstQuest: true,
            source: "quest_list",
            template: quest.questTemplateId.flatMap { questEngine.getTemplate(id: $0) },
            extra: questEngine.retentionAnalyticsProperties(context: persistence.container.viewContext).merging([
                "matches_all_preferences": quest.questTemplateId.flatMap { questEngine.getTemplate(id: $0) }.map {
                    questEngine.matchesAllPreferences(quest: $0, filterPrefs: questEngine.getFilterPreferences())
                } ?? false
            ], uniquingKeysWith: { _, new in new })
        ))
    }

    func trackMeaningfulActiveDayIfNeeded(stats: UserStats) {
        guard !dailyQuests.isEmpty else { return }
        analytics.trackMeaningfulActiveDay(source: "quest_board", lifecycle: lifecycle, userStats: stats)
    }
}
