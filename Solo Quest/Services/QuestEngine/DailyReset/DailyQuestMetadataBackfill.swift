//
//  DailyQuestMetadataBackfill.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func backfillDailyQuestMetadata(
    quests: [QuestInstance],
    gameDayID: String,
    limit: Int
) {
    guard limit > 0 else { return }

    let occupiedSlots = Set(quests.compactMap { quest -> Int16? in
        guard quest.logicalID != nil, quest.dailySlot >= 0 else { return nil }
        return quest.dailySlot
    })
    var availableSlots = Array(0..<limit)
        .compactMap(Int16.init(exactly:))
        .filter { !occupiedSlots.contains($0) }
    let questsMissingMetadata = quests.filter { $0.logicalID == nil }
    for quest in questsMissingMetadata where quest.id == nil {
        quest.id = UUID()
    }
    let orderedQuestsMissingMetadata = questsMissingMetadata.sorted { left, right in
        let leftDate = left.dateAssigned ?? .distantPast
        let rightDate = right.dateAssigned ?? .distantPast
        if leftDate != rightDate {
            return leftDate < rightDate
        }
        return (left.id?.uuidString ?? "") < (right.id?.uuidString ?? "")
    }

    for quest in orderedQuestsMissingMetadata {
        guard let ownerID = quest.ownerID, !availableSlots.isEmpty else { continue }
        let slot = availableSlots.removeFirst()
        quest.id = quest.id ?? UUID()
        quest.gameDayID = gameDayID
        quest.dailySlot = slot
        quest.logicalID = DailyQuestLogicalIdentifier.make(
            ownerID: ownerID,
            gameDayID: gameDayID,
            slot: slot,
            algorithmVersion: DailyResetAlgorithmVersion.value
        )
    }
}
