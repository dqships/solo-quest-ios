//
//  QuestEngine+CurrentDailyResetRecord.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func upsertCurrentDailyResetRecord(
        context: NSManagedObjectContext,
        gameDay: (start: Date, end: Date),
        dailyGenerationContext: DailyQuestGenerationContext
    ) {
        do {
            let record = try DailyResetRecordFactory.upsert(
                context: context,
                scope: accountScopeProvider.activeScope,
                gameDayID: dailyGenerationContext.gameDayID,
                gameDayStart: gameDay.start,
                gameDayEnd: gameDay.end
            )
            if record.questSeed == nil {
                record.questSeed = dailyGenerationContext.seed
            }
        } catch {
            print("⚠️ QuestEngine: Failed to upsert current daily reset record: \(error)")
        }
    }
}
