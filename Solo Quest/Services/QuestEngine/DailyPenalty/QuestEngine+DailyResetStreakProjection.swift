//
//  QuestEngine+DailyResetStreakProjection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

extension QuestEngine {
    func recomputeCurrentStreakFromDailyResetRecords(
        _ records: [DailyResetRecord],
        userStats: UserStats
    ) {
        let orderedRecords = records.sorted {
            let leftDate = $0.gameDayStart ?? .distantPast
            let rightDate = $1.gameDayStart ?? .distantPast
            if leftDate != rightDate {
                return leftDate < rightDate
            }
            return ($0.id?.uuidString ?? "") < ($1.id?.uuidString ?? "")
        }

        let outcomes = orderedRecords.map {
            DailyResetOutcomeValue(rawValue: $0.outcome ?? "") ?? .pending
        }
        userStats.currentStreak = projectDailyResetStreak(outcomes: outcomes)
    }
}
