//
//  QuestEngine+HardPreferenceCompliance.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension QuestEngine {
    /// Protects feasibility while allowing safer values and explicitly flexible metadata.
    func matchesAllHardPreferences(quest: QuestTemplate, filterPrefs: QuestFilterPreferences) -> Bool {
        if !filterPrefs.preferredSocialIntensities.isEmpty,
           let value = quest.socialIntensity,
           value != .strangers_optional,
           value.constraintRank > (filterPrefs.preferredSocialIntensities.map(\.constraintRank).max() ?? 0) {
            return false
        }
        if !filterPrefs.preferredEnergyLevels.isEmpty,
           let value = quest.energyLevel,
           value.constraintRank > (filterPrefs.preferredEnergyLevels.map(\.constraintRank).max() ?? 0) {
            return false
        }
        if !filterPrefs.preferredDurations.isEmpty,
           let value = quest.duration,
           value.constraintRank > (filterPrefs.preferredDurations.map(\.constraintRank).max() ?? 0) {
            return false
        }
        if !filterPrefs.preferredLocationTypes.isEmpty,
           let value = quest.locationType,
           value != .flexible,
           !filterPrefs.preferredLocationTypes.contains(value) {
            return false
        }
        if !filterPrefs.preferredCostLevels.isEmpty,
           let value = quest.costLevel,
           value.constraintRank > (filterPrefs.preferredCostLevels.map(\.constraintRank).max() ?? 0) {
            return false
        }
        return true
    }
}
