//
//  DailyResetRecordClosedDaysFetch.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

func fetchClosedDailyResetRecords(
    context: NSManagedObjectContext,
    scope: AccountScope,
    before date: Date
) throws -> [DailyResetRecord] {
    let request: NSFetchRequest<DailyResetRecord> = DailyResetRecord.fetchRequest()
    request.predicate = accountScopedPredicate(
        NSPredicate(format: "gameDayEnd <= %@", date as NSDate),
        scope: scope
    )
    request.sortDescriptors = [
        NSSortDescriptor(key: "gameDayStart", ascending: true),
        NSSortDescriptor(key: "id", ascending: true)
    ]
    return try context.fetch(request)
}
