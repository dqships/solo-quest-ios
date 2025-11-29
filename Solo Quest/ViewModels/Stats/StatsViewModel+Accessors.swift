//
//  StatsViewModel+Accessors.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Factory
import Foundation

extension StatsViewModel {
    func getQuestInstance(id: String) -> QuestInstance? {
        let context = persistence.container.viewContext

        if let uuid = UUID(uuidString: id) {
            let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
            request.predicate = accountScopedPredicate(NSPredicate(format: "id == %@", uuid as CVarArg), scope: Container.shared.accountScopeProvider().activeScope)
            request.fetchLimit = 1

            do {
                return try context.fetch(request).first
            } catch {
                print("❌ StatsViewModel: Error fetching quest instance: \(error)")
            }
        }
        return nil
    }

    func getTemplate(for questId: String) -> QuestTemplate? {
        questEngine.getTemplate(id: questId)
    }

    func getStatValue(_ statName: String) -> Int {
        guard let user = user else { return 0 }
        switch statName {
        case "luck": return user.stats.luck
        case "charisma": return user.stats.charisma
        case "strength": return user.stats.strength
        case "stamina": return user.stats.stamina
        case "resilience": return user.stats.resilience
        case "intelligence": return user.stats.intelligence
        default: return 0
        }
    }

    func getActivities(for statName: String) -> [ActivityLogItem] {
        guard let user = user else { return [] }
        return user.activityLog.filter { $0.deltaByStat.keys.contains(statName) }
    }
}
