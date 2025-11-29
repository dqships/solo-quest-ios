//
//  DailyResetStreakProjectionTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import XCTest
@testable import Solo_Quest

final class DailyResetStreakProjectionTests: XCTestCase {
    func testCountsEngagedSuffixAfterLatestReset() {
        let streak = projectDailyResetStreak(
            outcomes: [.protected, .engaged, .engaged, .pending]
        )

        XCTAssertEqual(streak, 2)
    }

    func testProtectedAndPenalizedOutcomesResetStreak() {
        XCTAssertEqual(
            projectDailyResetStreak(outcomes: [.engaged, .protected]),
            0
        )
        XCTAssertEqual(
            projectDailyResetStreak(outcomes: [.engaged, .penalized]),
            0
        )
    }

    func testPendingOutcomeDoesNotChangeStreak() {
        XCTAssertEqual(
            projectDailyResetStreak(outcomes: [.engaged, .pending, .engaged]),
            2
        )
    }

    func testCapsStreakAtInt16Maximum() {
        let outcomes = Array(repeating: DailyResetOutcomeValue.engaged, count: Int(Int16.max) + 1)
        XCTAssertEqual(projectDailyResetStreak(outcomes: outcomes), Int16.max)
    }
}
