//
//  DailyQuestGenerationContext.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

struct DailyQuestGenerationContext {
    let gameDayID: String
    let gameDayStart: Date
    let baseSeed: String
    let seed: String
    let slots: [Int16]

    init(
        gameDayID: String,
        gameDayStart: Date,
        baseSeed: String,
        seed: String,
        slots: [Int16]
    ) {
        self.gameDayID = gameDayID
        self.gameDayStart = gameDayStart
        self.baseSeed = baseSeed
        self.seed = seed
        self.slots = slots.sorted()
    }
}
