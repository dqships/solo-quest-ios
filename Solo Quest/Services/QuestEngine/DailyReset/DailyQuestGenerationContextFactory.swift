//
//  DailyQuestGenerationContextFactory.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

enum DailyQuestGenerationContextFactory {
    static func make(
        ownerID: String,
        gameDayStart: Date,
        slots: [Int16],
        calendar: Calendar,
        seedVariant: String? = nil
    ) -> DailyQuestGenerationContext {
        let gameDayID = GameDayIdentifier.make(gameDayStart: gameDayStart, calendar: calendar)
        let baseSeed = DailyQuestSeed.make(
            ownerID: ownerID,
            gameDayID: gameDayID,
            algorithmVersion: DailyResetAlgorithmVersion.value
        )
        let seed = seedVariant.map {
            DailyQuestSeedVariant.make(baseSeed: baseSeed, variant: $0)
        } ?? baseSeed
        return DailyQuestGenerationContext(
            gameDayID: gameDayID,
            gameDayStart: gameDayStart,
            baseSeed: baseSeed,
            seed: seed,
            slots: slots
        )
    }
}
