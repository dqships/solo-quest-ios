//
//  DailyPenaltyRecordTransition.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

struct DailyPenaltyRecordTransition {
    let record: DailyResetRecord
    let previousOutcome: DailyResetOutcomeValue
    let outcome: DailyResetOutcomeValue
    let previousPenaltyXP: Int64
    let penaltyXP: Int64
}
