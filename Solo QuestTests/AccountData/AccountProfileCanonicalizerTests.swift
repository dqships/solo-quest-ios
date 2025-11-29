//
//  AccountProfileCanonicalizerTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import XCTest
@testable import Solo_Quest

@MainActor
final class AccountProfileCanonicalizerTests: XCTestCase {
    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    override func setUp() async throws {
        try await PersistenceController.shared.waitForStoreLoad()
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "AccountProfile", context: context)
    }

    override func tearDown() async throws {
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "AccountProfile", context: context)
    }

    func testCanonicalizesOnlyRequestedOwnerAndIsIdempotent() throws {

        let winningID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")
        let losingID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")
        XCTAssertNotNil(winningID)
        XCTAssertNotNil(losingID)

        let first = AccountProfile(context: context)
        first.ownerID = "clerk:alpha"
        first.profileID = winningID
        first.createdAt = Date(timeIntervalSinceReferenceDate: 20)
        first.legacyClaimState = "unclaimed"

        let duplicate = AccountProfile(context: context)
        duplicate.ownerID = "clerk:alpha"
        duplicate.profileID = losingID
        duplicate.createdAt = Date(timeIntervalSinceReferenceDate: 10)
        duplicate.legacyClaimState = "claimed"

        let foreign = AccountProfile(context: context)
        foreign.ownerID = "clerk:beta"
        foreign.profileID = UUID()
        foreign.legacyClaimState = "unclaimed"

        try AccountProfileCanonicalizer.canonicalize(context: context, ownerIDs: ["clerk:alpha"])
        try AccountProfileCanonicalizer.canonicalize(context: context, ownerIDs: ["clerk:alpha"])

        let request: NSFetchRequest<AccountProfile> = AccountProfile.fetchRequest()
        let profiles = try context.fetch(request)
        let alphaProfiles = profiles.filter { $0.ownerID == "clerk:alpha" }
        XCTAssertEqual(alphaProfiles.count, 1)
        XCTAssertEqual(alphaProfiles.first?.profileID, winningID)
        XCTAssertEqual(alphaProfiles.first?.logicalID, "profile:clerk:alpha")
        XCTAssertEqual(alphaProfiles.first?.createdAt, Date(timeIntervalSinceReferenceDate: 10))
        XCTAssertEqual(alphaProfiles.first?.legacyClaimState, "claimed")
        XCTAssertEqual(profiles.filter { $0.ownerID == "clerk:beta" }.count, 1)
        XCTAssertNil(profiles.first { $0.ownerID == "clerk:beta" }?.logicalID)
    }
}
