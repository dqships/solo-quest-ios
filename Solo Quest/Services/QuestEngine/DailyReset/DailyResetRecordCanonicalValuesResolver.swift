//
//  DailyResetRecordCanonicalValuesResolver.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func dailyResetRecordCanonicalValues(for records: [DailyResetRecord]) -> DailyResetRecordCanonicalValues {
    let outcomes = records.compactMap { record in
        record.outcome.flatMap(DailyResetOutcomeValue.init(rawValue:))
    }
    let outcome = canonicalDailyResetOutcome(from: outcomes)
    let penaltyXP: Int64
    if outcome == .penalized {
        penaltyXP = records.map { max(Int64.zero, $0.penaltyXP) }.max() ?? 0
    } else {
        penaltyXP = 0
    }

    return DailyResetRecordCanonicalValues(
        outcome: outcome,
        penaltyXP: penaltyXP,
        gameDayStart: records.compactMap(\.gameDayStart).min(),
        gameDayEnd: records.compactMap(\.gameDayEnd).max(),
        processedAt: records.compactMap(\.processedAt).max(),
        questSeed: records.compactMap(\.questSeed).sorted().first,
        algorithmVersion: records.map(\.algorithmVersion).max() ?? DailyResetAlgorithmVersion.value
    )
}
