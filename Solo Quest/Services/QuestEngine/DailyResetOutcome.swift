//
//  DailyResetOutcome.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Foundation

struct DailyResetOutcome {
    let didReset: Bool
    let dailySkipPenaltyXP: Int?

    static let noReset = DailyResetOutcome(didReset: false, dailySkipPenaltyXP: nil)
}
