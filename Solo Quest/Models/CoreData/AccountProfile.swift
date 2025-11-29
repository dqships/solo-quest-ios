//
//  AccountProfile.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

@objc(AccountProfile)
public class AccountProfile: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountProfile> { NSFetchRequest(entityName: "AccountProfile") }
    @NSManaged public var profileID: UUID?
    @NSManaged public var logicalID: String?
    @NSManaged public var ownerID: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var legacyClaimState: String?
}
