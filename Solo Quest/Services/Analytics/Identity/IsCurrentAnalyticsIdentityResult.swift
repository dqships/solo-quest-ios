//
//  IsCurrentAnalyticsIdentityResult.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func isCurrentAnalyticsIdentityResult(
    expectation: AnalyticsIdentityExpectation,
    capturedRevision: Int,
    currentRevision: Int,
    currentClerkUserID: String?,
    revenueCatAppUserID: String,
    isRevenueCatAnonymous: Bool
) -> Bool {
    guard capturedRevision == currentRevision else { return false }

    switch expectation {
    case let .linked(clerkUserID):
        return currentClerkUserID == clerkUserID &&
            revenueCatAppUserID == clerkUserID &&
            !isRevenueCatAnonymous
    case .unlinked:
        return currentClerkUserID == nil && isRevenueCatAnonymous
    }
}
