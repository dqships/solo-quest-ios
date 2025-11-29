//
//  FirstWeekJourneyStage.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

struct FirstWeekJourneyStage {
    let activeDay: Int

    var title: String {
        switch activeDay {
        case 1: return String(localized: "First Win")
        case 2: return String(localized: "Momentum")
        case 3: return String(localized: "Your growing identity")
        case 4: return String(localized: "Choose your own path")
        case 5: return String(localized: "Growth")
        case 6: return String(localized: "Your adventure so far")
        default: return String(localized: "Your First Chapter")
        }
    }

    var message: String {
        switch activeDay {
        case 1: return String(localized: "Complete one useful quest and feel your first stat move.")
        case 2: return String(localized: "This is your second active day. Momentum is building.")
        case 3: return String(localized: "Your strongest stat is beginning to reveal your play style.")
        case 4: return String(localized: "Set your quest preferences so daily quests fit your time and energy.")
        case 5: return String(localized: "Pick the quest that feels like a useful stretch today.")
        case 6: return String(localized: "Your progress is evidence. Take a moment to notice what you have done.")
        default: return String(localized: "This chapter is built from real action, not perfect streaks.")
        }
    }
}
