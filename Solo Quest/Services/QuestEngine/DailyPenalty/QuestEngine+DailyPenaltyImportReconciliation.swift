//
//  QuestEngine+DailyPenaltyImportReconciliation.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func reconcileDailyPenaltyAfterImport(scopeViewIdentity: String) {
        let scope = accountScopeProvider.activeScope
        guard scope.viewIdentity == scopeViewIdentity else { return }
        guard let currentGameDay = gameDayBounds() else { return }

        let context = persistence.container.viewContext
        do {
            try DailyQuestDuplicateReconciler.reconcile(context: context, scope: scope)
            let records = try fetchDailyResetRecords(context: context, scope: scope)
            DailyResetRecordCanonicalizer.canonicalize(records: records, context: context)

            let userStats = fetchOrCreateUserStats(context: context)
            let transitions = reconcileLateDailyResetEngagement(
                context: context,
                userStats: userStats,
                before: currentGameDay.start
            )
            let appliedDelta = projectDailyPenaltyLedger(context: context, userStats: userStats)
            reconcileDailyPenaltyActivityLogs(context: context)
            trackDailyPenaltyTransitions(
                transitions,
                appliedDelta: appliedDelta,
                context: context,
                userStats: userStats
            )

            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("⚠️ QuestEngine: Daily penalty import reconciliation failed: \(error)")
        }
    }
}
