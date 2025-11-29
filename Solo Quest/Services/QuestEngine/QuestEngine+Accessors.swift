//
//  QuestEngine+Accessors.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension QuestEngine {
    func getTemplate(id: String) -> QuestTemplate? {
        return gameData?.quests.first(where: { $0.id == id })
    }

    func getFilterPreferences() -> QuestFilterPreferences {
        return filterPreferences
    }

    func updateFilterPreferences(_ prefs: QuestFilterPreferences) {
        let oldPreferences = filterPreferences
        filterPreferences = prefs
        prefs.save()
        if oldPreferences != prefs {
            analytics.track(event: "quest_preferences_changed", properties: prefs.analyticsProperties.merging([
                "source": "quest_preferences"
            ], uniquingKeysWith: { _, new in new }))
        }
        print("✅ QuestEngine: Updated filter preferences (\(prefs.activeFilterCount) active filters)")
    }

    func getRanks() -> [RankConfig] {
        return gameData?.config.ranks ?? []
    }

    func getDuration(size: String) -> QuestDuration {
        return gameData?.config.questSizeDurations[size] ?? QuestDuration(minMinutes: 15, maxMinutes: 15, defaultTimerMinutes: 15)
    }

    func getXP(size: String) -> Int {
        return gameData?.config.questSizes[size] ?? 100
    }

    func getLocalizedDisplayTitle(for instance: QuestInstance, template: QuestTemplate?) -> String {
        guard let template = template else {
            return instance.generatedTitle ?? "Unknown Quest"
        }

        if template.slots.isEmpty {
            return template.title
        }

        return instance.generatedTitle ?? template.title
    }
}
