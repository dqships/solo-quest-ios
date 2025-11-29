//
//  CalculateDailyPenaltyProjection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func calculateDailyPenaltyProjection(
    totalXP: Int64,
    previouslyAppliedPenaltyXP: Int64,
    targetPenaltyXP: Int64,
    minimumXP: Int64
) -> DailyPenaltyProjectionResult {
    let previousAppliedPenaltyXP = max(0, previouslyAppliedPenaltyXP)
    let (baseXPWithOverflow, didOverflow) = totalXP.addingReportingOverflow(previousAppliedPenaltyXP)
    let baseXP = didOverflow ? Int64.max : max(0, baseXPWithOverflow)
    let availablePenaltyXP = max(0, baseXP - minimumXP)
    let appliedPenaltyXP = min(max(0, targetPenaltyXP), availablePenaltyXP)
    let (appliedDelta, didOverflowDelta) = appliedPenaltyXP.subtractingReportingOverflow(previousAppliedPenaltyXP)

    return DailyPenaltyProjectionResult(
        totalXP: baseXP - appliedPenaltyXP,
        appliedPenaltyXP: appliedPenaltyXP,
        appliedDelta: didOverflowDelta ? 0 : appliedDelta
    )
}
