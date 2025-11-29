//
//  LegacyClaimAttemptRecorder.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import CryptoKit

enum LegacyClaimAttemptRecorder {
    static func record(
        context: NSManagedObjectContext,
        claimantOwnerID: String,
        eligibilityStore: LegacyUpgradeEligibilityStore
    ) throws -> LegacyDatasetClaim? {
        guard claimantOwnerID.hasPrefix("clerk:"), eligibilityStore.isEligible == true else { return nil }
        guard eligibilityStore.recordAttemptedClerkOwner(claimantOwnerID) else { return nil }

        let attemptID = deterministicAttemptID(
            claimantOwnerID: claimantOwnerID,
            installationID: eligibilityStore.installationID
        )
        let request: NSFetchRequest<LegacyDatasetClaim> = LegacyDatasetClaim.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "attemptID == %@", attemptID)
        if let existing = try context.fetch(request).first { return existing }

        let claim = LegacyDatasetClaim(context: context)
        claim.attemptID = attemptID
        claim.datasetID = LegacyClaimDatasetID.value
        claim.claimantOwnerID = claimantOwnerID
        claim.installationIDHash = eligibilityStore.installationIDHash
        claim.createdAt = Date()
        return claim
    }

    private static func deterministicAttemptID(claimantOwnerID: String, installationID: UUID) -> String {
        let value = "\(LegacyClaimDatasetID.value)|\(claimantOwnerID)|\(installationID.uuidString)"
        return SHA256.hash(data: Data(value.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}
