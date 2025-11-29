//
//  AnalyticsIdentityResultValidatorTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import XCTest
@testable import Solo_Quest

final class AnalyticsIdentityResultValidatorTests: XCTestCase {
    func testRejectsStaleRevision() {
        XCTAssertFalse(isCurrentAnalyticsIdentityResult(
            expectation: .linked(clerkUserID: "clerk:alpha"),
            capturedRevision: 1,
            currentRevision: 2,
            currentClerkUserID: "clerk:alpha",
            revenueCatAppUserID: "clerk:alpha",
            isRevenueCatAnonymous: false
        ))
    }

    func testRejectsClerkOrRevenueCatIdentityMismatch() {
        XCTAssertFalse(isCurrentAnalyticsIdentityResult(
            expectation: .linked(clerkUserID: "clerk:alpha"),
            capturedRevision: 1,
            currentRevision: 1,
            currentClerkUserID: "clerk:beta",
            revenueCatAppUserID: "clerk:alpha",
            isRevenueCatAnonymous: false
        ))
        XCTAssertFalse(isCurrentAnalyticsIdentityResult(
            expectation: .linked(clerkUserID: "clerk:alpha"),
            capturedRevision: 1,
            currentRevision: 1,
            currentClerkUserID: "clerk:alpha",
            revenueCatAppUserID: "clerk:beta",
            isRevenueCatAnonymous: false
        ))
    }

    func testRejectsAnonymousLinkedResultAndNonAnonymousUnlinkedResult() {
        XCTAssertFalse(isCurrentAnalyticsIdentityResult(
            expectation: .linked(clerkUserID: "clerk:alpha"),
            capturedRevision: 1,
            currentRevision: 1,
            currentClerkUserID: "clerk:alpha",
            revenueCatAppUserID: "clerk:alpha",
            isRevenueCatAnonymous: true
        ))
        XCTAssertFalse(isCurrentAnalyticsIdentityResult(
            expectation: .unlinked,
            capturedRevision: 1,
            currentRevision: 1,
            currentClerkUserID: nil,
            revenueCatAppUserID: "clerk:alpha",
            isRevenueCatAnonymous: false
        ))
    }

    func testAcceptsCurrentLinkedAndUnlinkedResults() {
        XCTAssertTrue(isCurrentAnalyticsIdentityResult(
            expectation: .linked(clerkUserID: "clerk:alpha"),
            capturedRevision: 1,
            currentRevision: 1,
            currentClerkUserID: "clerk:alpha",
            revenueCatAppUserID: "clerk:alpha",
            isRevenueCatAnonymous: false
        ))
        XCTAssertTrue(isCurrentAnalyticsIdentityResult(
            expectation: .unlinked,
            capturedRevision: 1,
            currentRevision: 1,
            currentClerkUserID: nil,
            revenueCatAppUserID: "$RCAnonymousID:test",
            isRevenueCatAnonymous: true
        ))
    }
}
