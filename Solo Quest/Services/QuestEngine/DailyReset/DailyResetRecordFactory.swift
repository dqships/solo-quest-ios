//
//  DailyResetRecordFactory.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

enum DailyResetRecordFactory {
    static func upsert(
        context: NSManagedObjectContext,
        scope: AccountScope,
        gameDayID: String,
        gameDayStart: Date,
        gameDayEnd: Date
    ) throws -> DailyResetRecord {
        let logicalID = DailyResetLogicalIdentifier.make(
            ownerID: scope.writeOwnerID,
            gameDayID: gameDayID,
            algorithmVersion: DailyResetAlgorithmVersion.value
        )
        let request: NSFetchRequest<DailyResetRecord> = DailyResetRecord.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "ownerID == %@", scope.writeOwnerID),
            NSPredicate(format: "logicalID == %@", logicalID)
        ])
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        if let record = try context.fetch(request).first {
            return record
        }

        let record = DailyResetRecord(context: context)
        record.id = UUID()
        record.ownerID = scope.writeOwnerID
        record.logicalID = logicalID
        record.gameDayID = gameDayID
        record.gameDayStart = gameDayStart
        record.gameDayEnd = gameDayEnd
        record.outcome = DailyResetOutcomeValue.pending.rawValue
        record.penaltyXP = 0
        record.algorithmVersion = DailyResetAlgorithmVersion.value
        return record
    }
}
