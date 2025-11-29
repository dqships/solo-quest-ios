//
//  QuestEngine+ExistingTemplateIDs.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func existingTemplateIDsForCurrentGameDay(
        context: NSManagedObjectContext,
        isSideQuest: Bool
    ) -> Set<String> {
        guard let gameDay = gameDayBounds() else { return [] }
        return Set(
            fetchQuestInstances(
                context: context,
                start: gameDay.start,
                end: gameDay.end,
                isSideQuest: isSideQuest
            ).compactMap(\.questTemplateId)
        )
    }
}
