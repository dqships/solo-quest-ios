//
//  ProjectDailyResetStreak.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func projectDailyResetStreak(outcomes: [DailyResetOutcomeValue]) -> Int16 {
    var streak = 0
    for outcome in outcomes {
        switch outcome {
        case .engaged:
            streak = min(streak + 1, Int(Int16.max))
        case .penalized, .protected:
            streak = 0
        case .pending:
            continue
        }
    }
    return Int16(streak)
}
