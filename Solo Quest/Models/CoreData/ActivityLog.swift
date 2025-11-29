//
//  ActivityLog.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import Foundation
import CoreData

@objc(ActivityLog)
public class ActivityLog: NSManagedObject, Identifiable {
    @NSManaged public var ownerID: String?
    @NSManaged public var logicalID: String?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityLog> {
        return NSFetchRequest<ActivityLog>(entityName: "ActivityLog")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var details: String?
    @NSManaged public var questInstanceId: UUID?
    @NSManaged public var questTemplateId: String?
    @NSManaged public var xpDelta: Int16
}
