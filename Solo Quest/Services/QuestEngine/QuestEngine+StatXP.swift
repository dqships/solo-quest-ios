//
//  QuestEngine+StatXP.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension QuestEngine {
    func statXP(for stat: String, in userStats: UserStats) -> Int64 {
        switch stat.lowercased() {
        case "luck": return userStats.luckXP
        case "charisma": return userStats.charismaXP
        case "strength": return userStats.strengthXP
        case "stamina": return userStats.staminaXP
        case "resilience": return userStats.resilienceXP
        case "intelligence": return userStats.intelligenceXP
        default: return 0
        }
    }
}
