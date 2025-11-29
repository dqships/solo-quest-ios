//
//  QuestEngine+DailyPenaltyProjection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func projectDailyPenaltyLedger(
        context: NSManagedObjectContext,
        userStats: UserStats
    ) -> Int64 {
        let scope = accountScopeProvider.activeScope
        guard let records = try? fetchDailyResetRecords(context: context, scope: scope) else {
            return 0
        }

        DailyResetRecordCanonicalizer.canonicalize(records: records, context: context)
        let canonicalRecords = (try? fetchDailyResetRecords(context: context, scope: scope)) ?? []
        let targetPenaltyXP = canonicalRecords.reduce(Int64.zero) { partialResult, record in
            guard DailyResetOutcomeValue(rawValue: record.outcome ?? "") == .penalized else {
                return partialResult
            }
            let (sum, overflow) = partialResult.addingReportingOverflow(max(0, record.penaltyXP))
            return overflow ? Int64.max : sum
        }
        let projection = calculateDailyPenaltyProjection(
            totalXP: userStats.totalXP,
            previouslyAppliedPenaltyXP: userStats.appliedDailyPenaltyXP,
            targetPenaltyXP: targetPenaltyXP,
            minimumXP: Int64(gameData?.config.penalties.minTotalXP ?? 0)
        )
        userStats.appliedDailyPenaltyXP = projection.appliedPenaltyXP
        userStats.totalXP = projection.totalXP
        return projection.appliedDelta
    }
}
