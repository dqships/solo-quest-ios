//
//  AccountProfileEnsurer.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

@discardableResult
func ensureAccountProfile(ownerID: String, context: NSManagedObjectContext) throws -> AccountProfile {
    let request: NSFetchRequest<AccountProfile> = AccountProfile.fetchRequest()
    request.predicate = NSPredicate(format: "ownerID == %@", ownerID)
    if try context.fetch(request).isEmpty {
        let profile = AccountProfile(context: context)
        profile.ownerID = ownerID
        profile.logicalID = "profile:\(ownerID)"
        profile.profileID = UUID()
        profile.createdAt = Date()
        profile.legacyClaimState = "unclaimed"
    }
    try AccountProfileCanonicalizer.canonicalize(
        context: context,
        ownerIDs: [ownerID]
    )

    let canonicalRequest: NSFetchRequest<AccountProfile> = AccountProfile.fetchRequest()
    canonicalRequest.fetchLimit = 1
    canonicalRequest.predicate = NSPredicate(format: "logicalID == %@", "profile:\(ownerID)")
    canonicalRequest.sortDescriptors = [NSSortDescriptor(key: "profileID", ascending: true)]
    guard let profile = try context.fetch(canonicalRequest).first else {
        throw AccountProfileEnsurerError.missingCanonicalProfile
    }
    return profile
}
