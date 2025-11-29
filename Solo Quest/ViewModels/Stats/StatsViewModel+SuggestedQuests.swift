//
//  StatsViewModel+SuggestedQuests.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension StatsViewModel {
    func getSuggestedQuests(for statName: String) -> [String] {
        switch statName {
        case "strength": return [
            String(localized: "Do 15 push ups"),
            String(localized: "Hold a plank"),
            String(localized: "Go for a run")
        ]
        case "charisma": return [
            String(localized: "Compliment a stranger"),
            String(localized: "Call an old friend"),
            String(localized: "Ask for a discount")
        ]
        case "intelligence": return [
            String(localized: "Read a book chapter"),
            String(localized: "Learn a new word"),
            String(localized: "Watch a documentary")
        ]
        case "stamina": return [
            String(localized: "Clean your room"),
            String(localized: "Walk for 30 mins"),
            String(localized: "No phone for 1 hour")
        ]
        case "resilience": return [
            String(localized: "Take a cold shower"),
            String(localized: "Do something scary"),
            String(localized: "Apologize to someone")
        ]
        case "luck": return [
            String(localized: "Try a new food"),
            String(localized: "Walk a new route"),
            String(localized: "Buy a lottery ticket")
        ]
        default: return []
        }
    }
}
