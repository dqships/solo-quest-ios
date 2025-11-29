//
//  StatMotivationText.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum StatMotivationText {
    static func text(for statName: String) -> String {
        let key = "stat.motivation.\(statName.lowercased())"
        let localized = String(localized: String.LocalizationValue(key))
        if localized == key {
            switch statName.lowercased() {
            case "strength": return "Do more physical quests like workouts, walks, or labor."
            case "charisma": return "Engage in social quests, conversations, and public speaking."
            case "intelligence": return "Focus on reading, learning, and problem-solving quests."
            case "stamina": return "Complete long-duration tasks and endurance challenges."
            case "luck": return "Take risks and try random new experiences."
            case "resilience": return "Push through discomfort and handle difficult situations."
            default: return "Keep completing quests to level up this stat."
            }
        }
        return localized
    }
}
