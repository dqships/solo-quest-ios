//
//  DailyResetRecordLogicalFetch.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

func fetchDailyResetRecords(
    context: NSManagedObjectContext,
    scope: AccountScope,
    logicalID: String
) throws -> [DailyResetRecord] {
    let request: NSFetchRequest<DailyResetRecord> = DailyResetRecord.fetchRequest()
    request.predicate = accountScopedPredicate(
        NSPredicate(format: "logicalID == %@", logicalID),
        scope: scope
    )
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    return try context.fetch(request)
}
