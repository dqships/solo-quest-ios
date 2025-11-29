//
//  DailyQuestDeterminismTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import XCTest
@testable import Solo_Quest

@MainActor
final class DailyQuestDeterminismTests: XCTestCase {
    func testDailySeedLogicalIdentifiersFractionsAndExactSlotsAreStable() {
        let gameDayStart = Date(timeIntervalSinceReferenceDate: 123_456)
        let calendar = Calendar(identifier: .gregorian)
        let firstContext = DailyQuestGenerationContextFactory.make(
            ownerID: "clerk:alpha",
            gameDayStart: gameDayStart,
            slots: [2, 0, 1],
            calendar: calendar
        )
        let repairedSlotContext = DailyQuestGenerationContextFactory.make(
            ownerID: "clerk:alpha",
            gameDayStart: gameDayStart,
            slots: [2],
            calendar: calendar
        )

        XCTAssertEqual(firstContext.seed, repairedSlotContext.seed)
        XCTAssertEqual(firstContext.slots, [0, 1, 2])
        XCTAssertEqual(repairedSlotContext.slots, [2])
        XCTAssertEqual(
            DailyQuestLogicalIdentifier.make(
                ownerID: "clerk:alpha",
                gameDayID: firstContext.gameDayID,
                slot: 2,
                algorithmVersion: DailyResetAlgorithmVersion.value
            ),
            DailyQuestLogicalIdentifier.make(
                ownerID: "clerk:alpha",
                gameDayID: repairedSlotContext.gameDayID,
                slot: 2,
                algorithmVersion: DailyResetAlgorithmVersion.value
            )
        )
        let slotTwoLogicalID = DailyQuestLogicalIdentifier.make(
            ownerID: "clerk:alpha",
            gameDayID: firstContext.gameDayID,
            slot: 2,
            algorithmVersion: DailyResetAlgorithmVersion.value
        )
        XCTAssertNotEqual(
            slotTwoLogicalID,
            DailyQuestLogicalIdentifier.make(
                ownerID: "clerk:beta",
                gameDayID: firstContext.gameDayID,
                slot: 2,
                algorithmVersion: DailyResetAlgorithmVersion.value
            )
        )
        XCTAssertNotEqual(
            slotTwoLogicalID,
            DailyQuestLogicalIdentifier.make(
                ownerID: "clerk:alpha",
                gameDayID: "America/Detroit|2026-08-26",
                slot: 2,
                algorithmVersion: DailyResetAlgorithmVersion.value
            )
        )
        XCTAssertNotEqual(
            slotTwoLogicalID,
            DailyQuestLogicalIdentifier.make(
                ownerID: "clerk:alpha",
                gameDayID: firstContext.gameDayID,
                slot: 1,
                algorithmVersion: DailyResetAlgorithmVersion.value
            )
        )

        let fullBoardFraction = DeterministicRandomFraction.make(
            seed: firstContext.seed,
            purpose: "weighted_draw|slot:2",
            index: 2
        )
        let repairedSlotFraction = DeterministicRandomFraction.make(
            seed: repairedSlotContext.seed,
            purpose: "weighted_draw|slot:2",
            index: 2
        )
        XCTAssertEqual(fullBoardFraction, repairedSlotFraction)
        XCTAssertGreaterThanOrEqual(fullBoardFraction, 0)
        XCTAssertLessThan(fullBoardFraction, 1)

        let questEngine = QuestEngine()
        let fullBoardQuests = questEngine.selectQuests(
            count: 3,
            userLevel: 100,
            preferredStats: [],
            filterPrefs: QuestFilterPreferences(),
            isNewPlayer: false,
            excludingTemplateIDs: [],
            rerollFeedbackOverride: [],
            dailyGenerationContext: firstContext
        )
        XCTAssertEqual(fullBoardQuests.count, 3)

        let repairedSlotQuests = questEngine.selectQuests(
            count: 1,
            userLevel: 100,
            preferredStats: [],
            filterPrefs: QuestFilterPreferences(),
            isNewPlayer: false,
            excludingTemplateIDs: Set(fullBoardQuests.prefix(2).map(\.id)),
            rerollFeedbackOverride: [],
            dailyGenerationContext: repairedSlotContext
        )
        XCTAssertEqual(repairedSlotQuests.count, 1)
        XCTAssertEqual(fullBoardQuests[2].id, repairedSlotQuests[0].id)
    }
}
