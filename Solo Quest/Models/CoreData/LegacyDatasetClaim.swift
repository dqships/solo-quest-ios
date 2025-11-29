//
//  LegacyDatasetClaim.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

@objc(LegacyDatasetClaim)
public class LegacyDatasetClaim: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LegacyDatasetClaim> {
        NSFetchRequest(entityName: "LegacyDatasetClaim")
    }

    @NSManaged public var attemptID: String?
    @NSManaged public var datasetID: String?
    @NSManaged public var claimantOwnerID: String?
    @NSManaged public var installationIDHash: String?
    @NSManaged public var createdAt: Date?
}
