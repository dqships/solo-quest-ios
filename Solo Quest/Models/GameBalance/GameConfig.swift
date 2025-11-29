//
//  GameConfig.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct GameConfig: Codable {
    let stats: [String]
    let dailyQuestRules: DailyQuestRules
    let sideQuestRules: SideQuestRules
    let questSizes: [String: Int]
    let questSizeDurations: [String: QuestDuration]
    let timerConfig: TimerConfig
    let levelConfig: LevelConfig
    let ranks: [RankConfig]
    let penalties: PenaltyConfig
}
