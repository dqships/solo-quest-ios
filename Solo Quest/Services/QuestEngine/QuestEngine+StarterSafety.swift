//
//  QuestEngine+StarterSafety.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension QuestEngine {
    func isStarterSafeQuest(_ quest: QuestTemplate) -> Bool {
        StarterQuestTemplateIDs.all.contains(quest.id) &&
        quest.size == "micro" &&
        quest.duration == .short_5_15 &&
        quest.costLevel == .free &&
        (quest.locationType == .home_indoor || quest.locationType == .flexible) &&
        (quest.socialIntensity == .solo || quest.socialIntensity == .strangers_optional) &&
        quest.energyLevel == .low &&
        quest.comfortZone == .easy
    }
}
