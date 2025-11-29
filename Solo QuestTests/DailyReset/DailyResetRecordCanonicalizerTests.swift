//
//  DailyResetRecordCanonicalizerTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import XCTest
@testable import Solo_Quest

@MainActor
final class DailyResetRecordCanonicalizerTests: XCTestCase {
    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    override func setUp() async throws {
        try await PersistenceController.shared.waitForStoreLoad()
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "DailyResetRecord", context: context)
    }

    override func tearDown() async throws {
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "DailyResetRecord", context: context)
    }

    func testKeepsSmallestUUIDWhileMergingStrongestOutcomeAndPenalty() throws {
        let logicalID = "reset-logical-id"

        let winner = DailyResetRecord(context: context)
        winner.id = UUID(uuidString: "00000000-0000-0000-0000-000000000001")
        winner.logicalID = logicalID
        winner.outcome = DailyResetOutcomeValue.pending.rawValue

        let smallerPenalty = DailyResetRecord(context: context)
        smallerPenalty.id = UUID(uuidString: "00000000-0000-0000-0000-000000000002")
        smallerPenalty.logicalID = logicalID
        smallerPenalty.outcome = DailyResetOutcomeValue.penalized.rawValue
        smallerPenalty.penaltyXP = 25

        let largerPenalty = DailyResetRecord(context: context)
        largerPenalty.id = UUID(uuidString: "00000000-0000-0000-0000-000000000003")
        largerPenalty.logicalID = logicalID
        largerPenalty.outcome = DailyResetOutcomeValue.penalized.rawValue
        largerPenalty.penaltyXP = 50

        DailyResetRecordCanonicalizer.canonicalize(
            records: [winner, smallerPenalty, largerPenalty],
            context: context
        )

        let request: NSFetchRequest<DailyResetRecord> = DailyResetRecord.fetchRequest()
        request.predicate = NSPredicate(format: "logicalID == %@", logicalID)
        let records = try context.fetch(request)
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.id, winner.id)
        XCTAssertEqual(records.first?.outcome, DailyResetOutcomeValue.penalized.rawValue)
        XCTAssertEqual(records.first?.penaltyXP, 50)
    }

    func testEngagedOutcomeOverridesPenaltyAndClearsPenaltyXP() throws {

        let penalized = DailyResetRecord(context: context)
        penalized.id = UUID(uuidString: "00000000-0000-0000-0000-000000000011")
        penalized.logicalID = "engagement-transition"
        penalized.outcome = DailyResetOutcomeValue.penalized.rawValue
        penalized.penaltyXP = 50

        let engaged = DailyResetRecord(context: context)
        engaged.id = UUID(uuidString: "00000000-0000-0000-0000-000000000012")
        engaged.logicalID = "engagement-transition"
        engaged.outcome = DailyResetOutcomeValue.engaged.rawValue
        engaged.penaltyXP = 10

        DailyResetRecordCanonicalizer.canonicalize(records: [penalized, engaged], context: context)

        XCTAssertEqual(penalized.outcome, DailyResetOutcomeValue.engaged.rawValue)
        XCTAssertEqual(penalized.penaltyXP, 0)
    }

    func testProtectedOutcomeOverridesPenaltyAndClearsPenaltyXP() throws {

        let protected = DailyResetRecord(context: context)
        protected.id = UUID(uuidString: "00000000-0000-0000-0000-000000000021")
        protected.logicalID = "protection-transition"
        protected.outcome = DailyResetOutcomeValue.protected.rawValue
        protected.penaltyXP = 10

        let penalized = DailyResetRecord(context: context)
        penalized.id = UUID(uuidString: "00000000-0000-0000-0000-000000000022")
        penalized.logicalID = "protection-transition"
        penalized.outcome = DailyResetOutcomeValue.penalized.rawValue
        penalized.penaltyXP = 50

        DailyResetRecordCanonicalizer.canonicalize(records: [protected, penalized], context: context)

        XCTAssertEqual(protected.outcome, DailyResetOutcomeValue.protected.rawValue)
        XCTAssertEqual(protected.penaltyXP, 0)
    }
}
