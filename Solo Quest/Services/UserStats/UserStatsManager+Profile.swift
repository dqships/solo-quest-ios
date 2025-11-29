//
//  UserStatsManager+Profile.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension UserStatsManager {
    func getUserStats() -> UserStats {
        let context = persistence.container.viewContext
        return fetchOrCreateUserStats(context: context)
    }

    func updateGoals(_ goals: Set<String>) {
        let context = persistence.container.viewContext
        let userStats = fetchOrCreateUserStats(context: context)
        userStats.goals = goals.sorted().joined(separator: ",")

        do {
            try context.save()
        } catch {
            print("❌ UserStatsManager: Failed to save goals: \(error)")
        }
    }

    func getGoals() -> Set<String> {
        let context = persistence.container.viewContext
        let userStats = fetchOrCreateUserStats(context: context)
        guard let goalsString = userStats.goals, !goalsString.isEmpty else {
            return []
        }
        return Set(goalsString.components(separatedBy: ","))
    }
}
