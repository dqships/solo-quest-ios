//
//  QuestEngine+DailySkipPenalty.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Foundation

extension QuestEngine {
    func dailySkipPenalty(for quests: [QuestInstance]) -> Int64 {
        let penaltyRate = gameData?.config.penalties.dailySkipPenaltyRate ?? 0.5
        let skippedQuestXP = quests.reduce(0) { total, quest in
            total + Int(quest.xpReward)
        }
        let fallbackQuestXP = (gameData?.config.questSizes["small"] ?? 100) * (gameData?.config.dailyQuestRules.questsPerDay ?? 3)
        let penaltyBaseXP = skippedQuestXP > 0 ? skippedQuestXP : fallbackQuestXP

        return Int64(Double(penaltyBaseXP) * penaltyRate)
    }
}
