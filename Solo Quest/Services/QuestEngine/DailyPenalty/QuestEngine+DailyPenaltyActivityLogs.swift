//
//  QuestEngine+DailyPenaltyActivityLogs.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func reconcileDailyPenaltyActivityLogs(context: NSManagedObjectContext) {
        let scope = accountScopeProvider.activeScope
        guard let records = try? fetchDailyResetRecords(context: context, scope: scope) else {
            return
        }

        DailyResetRecordCanonicalizer.canonicalize(records: records, context: context)
        let canonicalRecords = (try? fetchDailyResetRecords(context: context, scope: scope)) ?? []
        for record in canonicalRecords {
            reconcileDailyPenaltyActivityLog(context: context, record: record)
        }
    }

    private func reconcileDailyPenaltyActivityLog(
        context: NSManagedObjectContext,
        record: DailyResetRecord
    ) {
        guard let ownerID = record.ownerID, let resetLogicalID = record.logicalID else {
            return
        }

        let activityLogicalID = DailyPenaltyActivityLogicalIdentifier.make(resetLogicalID: resetLogicalID)
        let request: NSFetchRequest<ActivityLog> = ActivityLog.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "ownerID == %@", ownerID),
            NSPredicate(format: "logicalID == %@", activityLogicalID)
        ])

        guard let logs = try? context.fetch(request) else { return }
        let needsLog = DailyResetOutcomeValue(rawValue: record.outcome ?? "") == .penalized &&
            record.penaltyXP > 0
        guard needsLog else {
            for log in logs {
                context.delete(log)
            }
            return
        }

        for log in logs where log.id == nil {
            log.id = UUID()
        }
        let orderedLogs = logs.sorted { ($0.id?.uuidString ?? "") < ($1.id?.uuidString ?? "") }
        let log: ActivityLog
        if let existing = orderedLogs.first {
            log = existing
            for duplicate in orderedLogs.dropFirst() {
                context.delete(duplicate)
            }
        } else {
            log = ActivityLog(context: context)
            log.id = UUID()
        }

        log.ownerID = ownerID
        log.logicalID = activityLogicalID
        log.date = record.processedAt ?? record.gameDayEnd ?? Date()
        log.note = "Daily Skip Penalty"
        let cappedPenaltyXP = min(record.penaltyXP, Int64(Int16.max) + 1)
        log.xpDelta = Int16(-cappedPenaltyXP)
    }
}
