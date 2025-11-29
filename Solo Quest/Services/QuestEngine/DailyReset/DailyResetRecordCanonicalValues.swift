//
//  DailyResetRecordCanonicalValues.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

struct DailyResetRecordCanonicalValues {
    let outcome: DailyResetOutcomeValue
    let penaltyXP: Int64
    let gameDayStart: Date?
    let gameDayEnd: Date?
    let processedAt: Date?
    let questSeed: String?
    let algorithmVersion: Int16
}
