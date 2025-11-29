//
//  DailyResetRecordCanonicalizer.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

enum DailyResetRecordCanonicalizer {
    static func canonicalize(records: [DailyResetRecord], context: NSManagedObjectContext) {
        let groups = Dictionary(grouping: records.compactMap { record -> DailyResetRecord? in
            guard record.logicalID != nil else { return nil }
            return record
        }, by: { $0.logicalID ?? "" })

        for recordsWithLogicalID in groups.values {
            canonicalizeLogicalRecordGroup(recordsWithLogicalID, context: context)
        }
    }

    private static func canonicalizeLogicalRecordGroup(
        _ records: [DailyResetRecord],
        context: NSManagedObjectContext
    ) {
        guard !records.isEmpty else { return }

        for record in records where record.id == nil {
            record.id = UUID()
        }

        let orderedRecords = records.sorted {
            ($0.id?.uuidString ?? "") < ($1.id?.uuidString ?? "")
        }
        guard let winner = orderedRecords.first else { return }

        let values = dailyResetRecordCanonicalValues(for: records)
        winner.outcome = values.outcome.rawValue
        winner.penaltyXP = values.penaltyXP
        winner.gameDayStart = values.gameDayStart
        winner.gameDayEnd = values.gameDayEnd
        winner.processedAt = values.processedAt
        winner.questSeed = values.questSeed
        winner.algorithmVersion = values.algorithmVersion

        for loser in orderedRecords.dropFirst() {
            context.delete(loser)
        }
    }
}
