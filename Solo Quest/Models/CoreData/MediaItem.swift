//
//  MediaItem.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import Foundation
import CoreData

@objc(MediaItem)
public class MediaItem: NSManagedObject, Identifiable {
    @NSManaged public var ownerID: String?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MediaItem> {
        return NSFetchRequest<MediaItem>(entityName: "MediaItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var assetID: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var mediaType: String?
    @NSManaged public var caption: String?
    @NSManaged public var tag: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var quest: QuestInstance?

}
