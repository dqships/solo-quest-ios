//
//  DataResetService+CoreData.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import CoreData
import Foundation

extension DataResetService {
    func deleteCoreDataRecords() throws {
        let context = persistence.container.viewContext
        let names = ["UserStats", "QuestInstance", "ActivityLog", "MediaItem", "AccountProfile", "DailyResetRecord"]
        for name in names { try deleteRecords(entityName: name, context: context) }

        if context.hasChanges {
            try context.save()
        }
    }

    func activeMediaItemIDs() throws -> [UUID] {
        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)
        return try persistence.container.viewContext.fetch(request).compactMap(\.id)
    }

    private func deleteRecords(entityName: String, context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)
        request.includesPropertyValues = false
        try context.fetch(request).forEach(context.delete)
    }
}
