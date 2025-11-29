//
//  LegacyAccountOwnershipMigrator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

@MainActor
final class LegacyAccountOwnershipMigrator {
    func migrate(context: NSManagedObjectContext, scope: AccountScope) throws {
        try LegacyDatasetNormalizer.normalize(context: context)
        _ = try ensureAccountProfile(ownerID: scope.writeOwnerID, context: context)
        if context.hasChanges { try context.save() }
    }
}
