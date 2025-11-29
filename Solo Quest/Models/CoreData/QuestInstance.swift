//
//  QuestInstance.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import Foundation
import CoreData

@objc(QuestInstance)
public class QuestInstance: NSManagedObject, Identifiable {
    @NSManaged public var ownerID: String?
    @NSManaged public var logicalID: String?
    @NSManaged public var gameDayID: String?
    @NSManaged public var dailySlot: Int16

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestInstance> {
        return NSFetchRequest<QuestInstance>(entityName: "QuestInstance")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var questTemplateId: String?
    @NSManaged public var dateAssigned: Date?
    @NSManaged public var state: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var activationTime: Date?
    @NSManaged public var completionTime: Date?
    @NSManaged public var expiryTime: Date?
    @NSManaged public var isSideQuest: Bool
    @NSManaged public var generatedTitle: String?
    @NSManaged public var xpReward: Int16
    @NSManaged public var primaryStat: String?
    @NSManaged public var secondaryStats: String?
    @NSManaged public var notes: String?
    @NSManaged public var mediaItems: NSSet?
    
}

// MARK: - Helpers
extension QuestInstance {
    var secondaryStatsArray: [String] {
        return secondaryStats?.components(separatedBy: ",") ?? []
    }
    
    var computedState: QuestState {
        get { QuestState(rawValue: state ?? "available") ?? .available }
        set { state = newValue.rawValue }
    }

    @objc(addMediaItemsObject:)
    @NSManaged public func addToMediaItems(_ value: MediaItem)

    @objc(removeMediaItemsObject:)
    @NSManaged public func removeFromMediaItems(_ value: MediaItem)

    @objc(addMediaItems:)
    @NSManaged public func addToMediaItems(_ values: NSSet)

    @objc(removeMediaItems:)
    @NSManaged public func removeFromMediaItems(_ values: NSSet)
}

enum QuestState: String {
    case available
    case locked
    case active
    case completed
    case failed
}
