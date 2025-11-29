//
//  QuestListViewModel+StarterOrdering.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension QuestListViewModel {
    func starterPriority(for quest: QuestInstance) -> Int {
        guard user?.totalXp == 0,
              let templateID = quest.questTemplateId,
              StarterQuestTemplateIDs.all.contains(templateID) else {
            return 1
        }
        return 0
    }
}
