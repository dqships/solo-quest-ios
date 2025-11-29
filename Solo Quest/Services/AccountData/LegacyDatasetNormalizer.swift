//
//  LegacyDatasetNormalizer.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData

enum LegacyDatasetNormalizer {
    static func normalize(context: NSManagedObjectContext) throws {
        try inheritMediaItemOwners(context: context)
        try quarantineUnowned(UserStats.self, context: context)
        try quarantineUnowned(QuestInstance.self, context: context)
        try quarantineUnowned(ActivityLog.self, context: context)
        try quarantineUnowned(MediaItem.self, context: context)
    }


    private static func inheritMediaItemOwners(context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.predicate = NSPredicate(format: "ownerID == nil AND quest.ownerID != nil")
        for item in try context.fetch(request) { item.ownerID = item.quest?.ownerID }
    }

    private static func quarantineUnowned<T: NSManagedObject>(_ type: T.Type, context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = NSPredicate(format: "ownerID == nil")
        for object in try context.fetch(request) { object.setValue(AccountOwnerIDFactory.legacy, forKey: "ownerID") }
    }
}
