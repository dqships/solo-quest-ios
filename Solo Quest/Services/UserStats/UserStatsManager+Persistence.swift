//
//  UserStatsManager+Persistence.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension UserStatsManager {
    func fetchOrCreateUserStats(context: NSManagedObjectContext) -> UserStats {
        let request: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        request.fetchLimit = 1
        request.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)
        request.sortDescriptors = accountUserStatsSortDescriptors()

        do {
            let results = try context.fetch(request)
            if let first = results.first {
                return first
            }
        } catch {
            print("⚠️ UserStatsManager: Error fetching UserStats: \(error)")
        }

        let newStats = UserStats(context: context)
        newStats.level = 1
        newStats.rank = "E"
        newStats.totalXP = 0
        newStats.sideQuestCredits = 0
        newStats.ownerID = accountScopeProvider.activeScope.ownerID
        newStats.profileID = UUID()

        try? context.save()

        return newStats
    }
}
