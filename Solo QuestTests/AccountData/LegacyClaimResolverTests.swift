//
//  LegacyClaimResolverTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import XCTest
@testable import Solo_Quest

@MainActor
final class LegacyClaimResolverTests: XCTestCase {
    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    override func setUp() async throws {
        try await PersistenceController.shared.waitForStoreLoad()
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "LegacyDatasetClaim", context: context)
    }

    override func tearDown() async throws {
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "LegacyDatasetClaim", context: context)
    }

    func testResolvesUnclaimedSingleClaimantAndConflictFromPersistentClaims() throws {

        XCTAssertEqual(resolveLegacyClaims([]), .unclaimed)

        let incompleteClaim = LegacyDatasetClaim(context: context)
        incompleteClaim.attemptID = "attempt-incomplete"
        XCTAssertEqual(resolveLegacyClaims([incompleteClaim]), .unclaimed)

        let firstClaim = LegacyDatasetClaim(context: context)
        firstClaim.attemptID = "attempt-1"
        firstClaim.claimantOwnerID = "clerk:alpha"
        let duplicateClaim = LegacyDatasetClaim(context: context)
        duplicateClaim.attemptID = "attempt-1"
        duplicateClaim.claimantOwnerID = "clerk:alpha"
        XCTAssertEqual(
            resolveLegacyClaims([incompleteClaim, firstClaim, duplicateClaim]),
            .claimed("clerk:alpha")
        )

        let competingClaim = LegacyDatasetClaim(context: context)
        competingClaim.attemptID = "attempt-2"
        competingClaim.claimantOwnerID = "clerk:beta"
        XCTAssertEqual(
            resolveLegacyClaims([incompleteClaim, firstClaim, duplicateClaim, competingClaim]),
            .conflict
        )
    }
}
