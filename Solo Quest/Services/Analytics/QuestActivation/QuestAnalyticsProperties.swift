//
//  QuestAnalyticsProperties.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import Foundation

enum QuestAnalyticsProperties {
    static func make(
        quest: QuestInstance,
        userStats: UserStats,
        isPro: Bool,
        isFirstQuest: Bool,
        source: String,
        template: QuestTemplate? = nil,
        extra: [String: Any] = [:]
    ) -> [String: Any] {
        var properties: [String: Any] = [
            "quest_id": quest.id?.uuidString ?? "unknown",
            "quest_template_id": quest.questTemplateId ?? "unknown",
            "quest_title_present": quest.generatedTitle?.isEmpty == false,
            "quest_category": quest.primaryStat ?? "unknown",
            "quest_secondary_stats": quest.secondaryStats ?? "none",
            "quest_state": quest.state ?? "unknown",
            "quest_difficulty": questDifficulty(for: quest),
            "quest_xp_reward": Int(quest.xpReward),
            "is_side_quest": quest.isSideQuest,
            "is_first_quest": isFirstQuest,
            "source": source,
            "user_level": Int(userStats.level),
            "user_rank": userStats.rank ?? "E",
            "user_total_xp": Int(userStats.totalXP),
            "user_current_streak": Int(userStats.currentStreak),
            "side_quest_credits": Int(userStats.sideQuestCredits),
            "is_pro": isPro
        ]

        if let template {
            properties.merge(templateProperties(template), uniquingKeysWith: { _, new in new })
        }

        if let assigned = quest.dateAssigned {
            properties["quest_assigned_at"] = AnalyticsDateFormatter.string(from: assigned)
        }

        if let start = quest.startTime {
            properties["quest_started_at"] = AnalyticsDateFormatter.string(from: start)
        }

        if let completion = quest.completionTime {
            properties["quest_completed_at"] = AnalyticsDateFormatter.string(from: completion)
        }

        properties.merge(extra, uniquingKeysWith: { _, new in new })
        return properties
    }

    static func generated(
        count: Int,
        userStats: UserStats,
        isPro: Bool,
        source: String,
        isFirstGeneration: Bool
    ) -> [String: Any] {
        [
            "quest_count": count,
            "source": source,
            "is_first_quest_generation": isFirstGeneration,
            "user_level": Int(userStats.level),
            "user_rank": userStats.rank ?? "E",
            "user_total_xp": Int(userStats.totalXP),
            "user_current_streak": Int(userStats.currentStreak),
            "side_quest_credits": Int(userStats.sideQuestCredits),
            "is_pro": isPro
        ]
    }

    private static func questDifficulty(for quest: QuestInstance) -> String {
        guard let templateId = quest.questTemplateId else { return "unknown" }

        switch templateId {
        case let value where value.contains("micro"):
            return "micro"
        case let value where value.contains("small"):
            return "small"
        case let value where value.contains("medium"):
            return "medium"
        case let value where value.contains("big"):
            return "big"
        default:
            return "unknown"
        }
    }

    private static func templateProperties(_ template: QuestTemplate) -> [String: Any] {
        [
            "quest_category": template.category?.rawValue ?? "unknown",
            "quest_difficulty": template.size,
            "energy_level": template.energyLevel?.rawValue ?? "unknown",
            "duration": template.duration?.rawValue ?? "unknown",
            "social_intensity": template.socialIntensity?.rawValue ?? "unknown",
            "location_type": template.locationType?.rawValue ?? "unknown",
            "cost_level": template.costLevel?.rawValue ?? "unknown",
            "comfort_zone": template.comfortZone?.rawValue ?? "unknown",
            "time_of_day": template.timeOfDay?.rawValue ?? "unknown"
        ]
    }
}
