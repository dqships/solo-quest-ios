//
//  RevenueCatCallbackIdentityTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import XCTest
@testable import Solo_Quest

final class RevenueCatCallbackIdentityTests: XCTestCase {
    func testRejectsDelegateCallbackCapturedForPreviousRevenueCatIdentity() {
        let capturedIdentity = RevenueCatCallbackIdentity(
            revenueCatAppUserID: "clerk:alpha",
            isRevenueCatAnonymous: false
        )
        let currentIdentity = PenaltyRefreshIdentitySnapshot(
            clerkUserID: "clerk:beta",
            revenueCatAppUserID: "clerk:beta",
            isRevenueCatAnonymous: false
        )

        XCTAssertFalse(
            isCurrentRevenueCatCallbackIdentity(
                capturedIdentity,
                currentIdentity: currentIdentity
            )
        )
    }

    func testAcceptsDelegateCallbackForMatchingRevenueCatIdentity() {
        let capturedIdentity = RevenueCatCallbackIdentity(
            revenueCatAppUserID: "$RCAnonymousID:current",
            isRevenueCatAnonymous: true
        )
        let currentIdentity = PenaltyRefreshIdentitySnapshot(
            clerkUserID: nil,
            revenueCatAppUserID: "$RCAnonymousID:current",
            isRevenueCatAnonymous: true
        )

        XCTAssertTrue(
            isCurrentRevenueCatCallbackIdentity(
                capturedIdentity,
                currentIdentity: currentIdentity
            )
        )
    }
}
