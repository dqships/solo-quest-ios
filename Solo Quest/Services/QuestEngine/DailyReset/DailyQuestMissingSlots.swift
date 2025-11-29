//
//  DailyQuestMissingSlots.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func missingDailyQuestSlots(quests: [QuestInstance], limit: Int) -> [Int16] {
    let occupiedSlots = Set(quests.compactMap { quest -> Int16? in
        guard quest.logicalID != nil, quest.dailySlot >= 0 else { return nil }
        return quest.dailySlot
    })
    return Array(0..<limit)
        .compactMap(Int16.init(exactly:))
        .filter { !occupiedSlots.contains($0) }
}
