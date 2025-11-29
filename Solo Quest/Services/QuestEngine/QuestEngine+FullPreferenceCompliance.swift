//
//  QuestEngine+FullPreferenceCompliance.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension QuestEngine {
    func matchesAllPreferences(quest: QuestTemplate, filterPrefs: QuestFilterPreferences) -> Bool {
        guard matchesAllHardPreferences(quest: quest, filterPrefs: filterPrefs) else { return false }
        return matchesPreferredFilters(quest: quest, filterPrefs: filterPrefs)
    }
}
