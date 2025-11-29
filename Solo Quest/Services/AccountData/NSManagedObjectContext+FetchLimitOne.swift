//
//  NSManagedObjectContext+FetchLimitOne.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData

extension NSManagedObjectContext {
    func fetchLimitOne<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> T? {
        request.fetchLimit = 1
        return try fetch(request).first
    }
}
