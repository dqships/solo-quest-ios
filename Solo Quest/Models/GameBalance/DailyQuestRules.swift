//
//  DailyQuestRules.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct DailyQuestRules: Codable {
    let questsPerDay: Int
    let requiredAttempts: Int
    let applySkipPenalty: Bool
}
