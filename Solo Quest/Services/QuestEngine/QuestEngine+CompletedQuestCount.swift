//
//  QuestEngine+CompletedQuestCount.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func completedQuestCount(context: NSManagedObjectContext) -> Int {
        let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        request.predicate = accountScopedPredicate(NSPredicate(format: "isSideQuest == NO AND state == %@", "completed"), scope: accountScopeProvider.activeScope)
        return (try? context.count(for: request)) ?? 0
    }
}
