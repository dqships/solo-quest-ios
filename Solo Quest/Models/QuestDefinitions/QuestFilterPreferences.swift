//
//  QuestFilterPreferences.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

/// Stores the user's quest preferences. Persisted to UserDefaults as JSON.
struct QuestFilterPreferences: Codable, Equatable {
    var preferredCategories: [QuestCategory] = []
    var preferredSocialIntensities: [SocialIntensity] = []
    var preferredEnergyLevels: [EnergyLevel] = []
    var preferredDurations: [DurationBucket] = []
    var preferredLocationTypes: [LocationType] = []
    var preferredCostLevels: [CostLevel] = []
    var preferredTimeOfDay: [TimeOfDay] = []
    var preferredComfortZones: [ComfortZone] = []

    /// True if the user has set any preferences at all
    var hasAnyPreferences: Bool {
        return !preferredCategories.isEmpty ||
               !preferredSocialIntensities.isEmpty ||
               !preferredEnergyLevels.isEmpty ||
               !preferredDurations.isEmpty ||
               !preferredLocationTypes.isEmpty ||
               !preferredCostLevels.isEmpty ||
               !preferredTimeOfDay.isEmpty ||
               !preferredComfortZones.isEmpty
    }

    /// Returns the total number of active filter selections
    var activeFilterCount: Int {
        return preferredCategories.count +
               preferredSocialIntensities.count +
               preferredEnergyLevels.count +
               preferredDurations.count +
               preferredLocationTypes.count +
               preferredCostLevels.count +
               preferredTimeOfDay.count +
               preferredComfortZones.count
    }

    private static let storageKey = "SoloQuest.QuestFilterPreferences"

    static func load() -> QuestFilterPreferences {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let prefs = try? JSONDecoder().decode(QuestFilterPreferences.self, from: data) else {
            return QuestFilterPreferences()
        }
        return prefs
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }
}
