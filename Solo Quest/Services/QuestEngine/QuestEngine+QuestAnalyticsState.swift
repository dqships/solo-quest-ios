//
//  QuestEngine+QuestAnalyticsState.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func isFirstQuestStart(_ quest: QuestInstance, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        request.fetchLimit = 1
        request.predicate = accountScopedPredicate(NSPredicate(
            format: "isSideQuest == NO AND self != %@ AND (startTime != nil OR state IN %@)",
            quest,
            ["locked", "active", "completed", "failed"]
        ), scope: accountScopeProvider.activeScope)

        return ((try? context.count(for: request)) ?? 0) == 0
    }

    func isFirstQuestCompletion(_ quest: QuestInstance, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        request.fetchLimit = 1
        request.predicate = accountScopedPredicate(NSPredicate(
            format: "isSideQuest == NO AND self != %@ AND state == %@",
            quest,
            "completed"
        ), scope: accountScopeProvider.activeScope)

        return ((try? context.count(for: request)) ?? 0) == 0
    }

    func isFirstQuestGeneration(context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        request.fetchLimit = 1
        request.predicate = accountScopedPredicate(NSPredicate(format: "isSideQuest == NO"), scope: accountScopeProvider.activeScope)

        return ((try? context.count(for: request)) ?? 0) == 0
    }
}
