//
//  PenaltyEntitlementDecision.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

/// The only entitlement states the daily-penalty system may act on.
/// Unresolved deliberately prevents destructive penalty mutations.
enum PenaltyEntitlementDecision: Equatable {
    case pro
    case freeVerified
    case unresolved
}
