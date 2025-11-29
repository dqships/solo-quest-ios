//
//  CanonicalDailyResetOutcome.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func canonicalDailyResetOutcome(from outcomes: [DailyResetOutcomeValue]) -> DailyResetOutcomeValue {
    if outcomes.contains(.engaged) {
        return .engaged
    }
    if outcomes.contains(.protected) {
        return .protected
    }
    if outcomes.contains(.penalized) {
        return .penalized
    }
    return .pending
}
