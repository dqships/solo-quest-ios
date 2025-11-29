//
//  CoreDataTestEntityCleaner.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData

enum CoreDataTestEntityCleaner {
    static func deleteAll(entityNamed entityName: String, context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        for object in try context.fetch(request) {
            context.delete(object)
        }
        if context.hasChanges {
            try context.save()
        }
        context.reset()
    }
}
