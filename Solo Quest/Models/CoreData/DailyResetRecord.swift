//
//  DailyResetRecord.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

@objc(DailyResetRecord)
public class DailyResetRecord: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyResetRecord> { NSFetchRequest(entityName: "DailyResetRecord") }
    @NSManaged public var id: UUID?
    @NSManaged public var ownerID: String?
    @NSManaged public var logicalID: String?
    @NSManaged public var gameDayID: String?
    @NSManaged public var gameDayStart: Date?
    @NSManaged public var gameDayEnd: Date?
    @NSManaged public var outcome: String?
    @NSManaged public var penaltyXP: Int64
    @NSManaged public var questSeed: String?
    @NSManaged public var processedAt: Date?
    @NSManaged public var algorithmVersion: Int16
}
