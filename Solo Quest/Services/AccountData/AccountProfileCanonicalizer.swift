//
//  AccountProfileCanonicalizer.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

enum AccountProfileCanonicalizer {
    static func canonicalize(
        context: NSManagedObjectContext,
        ownerIDs: Set<String>
    ) throws {
        guard !ownerIDs.isEmpty else { return }

        let request: NSFetchRequest<AccountProfile> = AccountProfile.fetchRequest()
        request.predicate = NSPredicate(format: "ownerID IN %@", Array(ownerIDs))
        let profiles = try context.fetch(request)
        for profile in profiles {
            guard let ownerID = profile.ownerID else { continue }

            profile.logicalID = "profile:\(ownerID)"
            profile.profileID = profile.profileID ?? UUID()
            profile.createdAt = profile.createdAt ?? Date()
        }
        let groups = Dictionary(grouping: profiles.compactMap { profile -> AccountProfile? in
            guard profile.logicalID != nil else { return nil }
            return profile
        }, by: { $0.logicalID ?? "" })
        for group in groups.values where group.count > 1 {
            let ordered = group.sorted { ($0.profileID?.uuidString ?? "") < ($1.profileID?.uuidString ?? "") }
            guard let winner = ordered.first else { continue }
            winner.createdAt = group.compactMap(\.createdAt).min()
            winner.legacyClaimState = strongestState(group.compactMap(\.legacyClaimState))
            for loser in ordered.dropFirst() { context.delete(loser) }
        }
    }

    private static func strongestState(_ states: [String]) -> String {
        if states.contains("conflict") { return "conflict" }
        if states.contains("claimed") { return "claimed" }
        return "unclaimed"
    }
}
