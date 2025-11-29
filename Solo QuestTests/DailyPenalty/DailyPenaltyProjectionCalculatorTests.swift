//
//  DailyPenaltyProjectionCalculatorTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import XCTest
@testable import Solo_Quest

final class DailyPenaltyProjectionCalculatorTests: XCTestCase {
    func testRefundsExactlyWhenCanonicalTargetDrops() {
        let projection = calculateDailyPenaltyProjection(
            totalXP: 60,
            previouslyAppliedPenaltyXP: 40,
            targetPenaltyXP: 10,
            minimumXP: 0
        )

        XCTAssertEqual(projection.totalXP, 90)
        XCTAssertEqual(projection.appliedPenaltyXP, 10)
        XCTAssertEqual(projection.appliedDelta, -30)
    }

    func testCapsPenaltyAtConfiguredMinimumXP() {
        let projection = calculateDailyPenaltyProjection(
            totalXP: 55,
            previouslyAppliedPenaltyXP: 0,
            targetPenaltyXP: 20,
            minimumXP: 50
        )

        XCTAssertEqual(projection.totalXP, 50)
        XCTAssertEqual(projection.appliedPenaltyXP, 5)
        XCTAssertEqual(projection.appliedDelta, 5)
    }

    func testZeroOrNegativeTargetRestoresPreviouslyAppliedMarker() {
        let zeroTarget = calculateDailyPenaltyProjection(
            totalXP: 80,
            previouslyAppliedPenaltyXP: 20,
            targetPenaltyXP: 0,
            minimumXP: 0
        )
        let negativeTarget = calculateDailyPenaltyProjection(
            totalXP: 80,
            previouslyAppliedPenaltyXP: 20,
            targetPenaltyXP: -10,
            minimumXP: 0
        )

        XCTAssertEqual(zeroTarget.totalXP, 100)
        XCTAssertEqual(zeroTarget.appliedPenaltyXP, 0)
        XCTAssertEqual(zeroTarget.appliedDelta, -20)
        XCTAssertEqual(negativeTarget.totalXP, zeroTarget.totalXP)
        XCTAssertEqual(negativeTarget.appliedPenaltyXP, zeroTarget.appliedPenaltyXP)
        XCTAssertEqual(negativeTarget.appliedDelta, zeroTarget.appliedDelta)
    }
}
