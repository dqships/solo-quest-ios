//
//  QuestCompletionReward.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

struct QuestCompletionReward: Identifiable {
    let id: UUID
    let questTitle: String
    let questTemplateID: String
    let questCategory: String
    let questDifficulty: String
    let xpEarned: Int
    let primaryStat: String
    let statXPBefore: Int64
    let statXPAfter: Int64
    let levelBefore: Int
    let level: Int
    let rankBefore: String
    let rank: String
    let levelProgressBefore: Double
    let levelProgressAfter: Double
    let isFirstCompletion: Bool
    let userTotalXP: Int
    let userCurrentStreak: Int
    let activeDaysLifetime: Int
    let daysSinceInstall: Int
    let newUserProtectionActive: Bool
}
