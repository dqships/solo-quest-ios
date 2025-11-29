//
//  QuestFilterPreferencesFingerprint.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

enum QuestFilterPreferencesFingerprint {
    static func make(for preferences: QuestFilterPreferences) -> String {
        [
            preferences.preferredCategories.map(\.rawValue),
            preferences.preferredSocialIntensities.map(\.rawValue),
            preferences.preferredEnergyLevels.map(\.rawValue),
            preferences.preferredDurations.map(\.rawValue),
            preferences.preferredLocationTypes.map(\.rawValue),
            preferences.preferredCostLevels.map(\.rawValue),
            preferences.preferredTimeOfDay.map(\.rawValue),
            preferences.preferredComfortZones.map(\.rawValue)
        ]
        .map { $0.sorted().joined(separator: ",") }
        .joined(separator: "|")
    }
}
