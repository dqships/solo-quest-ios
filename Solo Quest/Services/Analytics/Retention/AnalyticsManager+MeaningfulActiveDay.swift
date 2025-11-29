//
//  AnalyticsManager+MeaningfulActiveDay.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension AnalyticsManager {
    @MainActor
    func trackMeaningfulActiveDay(
        source: String,
        lifecycle: PlayerLifecycleService,
        userStats: UserStats? = nil
    ) {
        guard let milestone = lifecycle.recordMeaningfulActiveDay() else { return }
        var properties: [String: Any] = [
            "source": source,
            "active_days_lifetime": lifecycle.activeDaysLifetime,
            "days_since_install": lifecycle.daysSinceInstall()
        ]
        if let userStats {
            properties["user_level"] = Int(userStats.level)
            properties["user_rank"] = userStats.rank ?? "E"
            properties["user_total_xp"] = Int(userStats.totalXP)
            properties["user_current_streak"] = Int(userStats.currentStreak)
        }

        track(event: "meaningful_active_day", properties: properties)
        if milestone.isDayOneReturn, lifecycle.shouldTrackFirstEvent("day_1_return") {
            track(event: "day_1_return", properties: properties)
        }
        if milestone.activeDayNumber == 2, lifecycle.shouldTrackFirstEvent("second_active_day") {
            track(event: "second_active_day", properties: properties)
        }
        if milestone.isDaySevenReturn, lifecycle.shouldTrackFirstEvent("day_7_return") {
            track(event: "day_7_return", properties: properties)
        }
    }
}
