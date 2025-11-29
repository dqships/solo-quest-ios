//
//  QuestEngine+Persistence.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension QuestEngine {
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
            print("⚠️ QuestEngine: Error fetching UserStats: \(error)")
        }

        let newStats = UserStats(context: context)
        newStats.level = 1
        newStats.rank = "E"
        newStats.totalXP = 0
        newStats.sideQuestCredits = 0
        newStats.ownerID = accountScopeProvider.activeScope.ownerID
        newStats.profileID = UUID()
        return newStats
    }

    func logActivity(context: NSManagedObjectContext, note: String, xp: Int, quest: QuestInstance? = nil, details: String? = nil) {
        let scope = accountScopeProvider.activeScope
        if let quest, !isOwnedByActiveAccount(quest, scope: scope) {
            print("⚠️ QuestEngine: Refused cross-account activity creation")
            return
        }
        let log = ActivityLog(context: context)
        log.ownerID = quest?.ownerID ?? scope.ownerID
        log.id = UUID()
        log.date = Date()
        log.note = note
        log.details = details
        log.xpDelta = Int16(xp)
        if let quest = quest {
            log.questInstanceId = quest.id
            log.questTemplateId = quest.questTemplateId
        }
    }


    func saveContext() {
        do {
            try persistence.container.viewContext.save()
        } catch {
            print("❌ QuestEngine: Save failed: \(error)")
        }
    }
}
