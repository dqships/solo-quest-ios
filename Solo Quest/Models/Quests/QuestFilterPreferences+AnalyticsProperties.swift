//
//  QuestFilterPreferences+AnalyticsProperties.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension QuestFilterPreferences {
    var analyticsProperties: [String: Any] {
        [
            "active_filter_count": activeFilterCount,
            "quest_categories": preferredCategories.map(\.rawValue),
            "social_intensities": preferredSocialIntensities.map(\.rawValue),
            "energy_levels": preferredEnergyLevels.map(\.rawValue),
            "durations": preferredDurations.map(\.rawValue),
            "location_types": preferredLocationTypes.map(\.rawValue),
            "cost_levels": preferredCostLevels.map(\.rawValue),
            "times_of_day": preferredTimeOfDay.map(\.rawValue),
            "comfort_zones": preferredComfortZones.map(\.rawValue)
        ]
    }
}
