//
//  DailyResetRecordScopeFetch.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

func fetchDailyResetRecords(
    context: NSManagedObjectContext,
    scope: AccountScope
) throws -> [DailyResetRecord] {
    let request: NSFetchRequest<DailyResetRecord> = DailyResetRecord.fetchRequest()
    request.predicate = accountOwnedPredicate(scope)
    request.sortDescriptors = [
        NSSortDescriptor(key: "gameDayStart", ascending: true),
        NSSortDescriptor(key: "id", ascending: true)
    ]
    return try context.fetch(request)
}
