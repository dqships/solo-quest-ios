//
//  QuestEngine+MissedGameDayReconciliation.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func reconcileMissedGameDays(
        context: NSManagedObjectContext,
        userStats: UserStats,
        currentGameDay: (start: Date, end: Date),
        entitlementDecision: PenaltyEntitlementDecision
    ) -> Int? {
        guard let lastDate = userStats.lastDailyGenerationDate,
              var gameDay = gameDayBounds(containing: lastDate) else {
            return nil
        }

        let calendar = Calendar.current
        var transitions: [DailyPenaltyRecordTransition] = []
        while gameDay.start < currentGameDay.start {
            if let transition = reconcileClosedGameDay(
                context: context,
                userStats: userStats,
                gameDay: gameDay,
                entitlementDecision: entitlementDecision
            ) {
                transitions.append(transition)
            }
            guard let nextLocalDate = calendar.date(byAdding: .day, value: 1, to: gameDay.start),
                  let nextGameDay = gameDayBounds(containing: nextLocalDate) else {
                break
            }
            gameDay = nextGameDay
        }

        transitions.append(contentsOf: reconcileLateDailyResetEngagement(
            context: context,
            userStats: userStats,
            before: currentGameDay.start
        ))
        let appliedDelta = projectDailyPenaltyLedger(context: context, userStats: userStats)
        reconcileDailyPenaltyActivityLogs(context: context)
        trackDailyPenaltyTransitions(
            transitions,
            appliedDelta: appliedDelta,
            context: context,
            userStats: userStats
        )
        return appliedDelta > 0 ? Int(appliedDelta) : nil
    }

    func reconcileLateDailyResetEngagement(
        context: NSManagedObjectContext,
        userStats: UserStats,
        before date: Date
    ) -> [DailyPenaltyRecordTransition] {
        let scope = accountScopeProvider.activeScope
        guard let records = try? fetchClosedDailyResetRecords(
            context: context,
            scope: scope,
            before: date
        ) else {
            return []
        }

        DailyResetRecordCanonicalizer.canonicalize(records: records, context: context)
        let canonicalRecords = (try? fetchClosedDailyResetRecords(
            context: context,
            scope: scope,
            before: date
        )) ?? []
        var transitions: [DailyPenaltyRecordTransition] = []
        for record in canonicalRecords {
            guard let start = record.gameDayStart, let end = record.gameDayEnd else {
                continue
            }
            let quests = fetchQuestInstances(context: context, start: start, end: end, isSideQuest: false)
            let trackedEngagement = userStats.lastQuestEngagementDate.map {
                $0 >= start && $0 < end
            } ?? false
            let engaged = trackedEngagement || quests.contains { $0.state != "available" }
            let previousOutcome = DailyResetOutcomeValue(rawValue: record.outcome ?? "") ?? .pending
            let previousPenaltyXP = max(0, record.penaltyXP)
            guard engaged, previousOutcome != .engaged else { continue }

            record.outcome = DailyResetOutcomeValue.engaged.rawValue
            record.penaltyXP = 0
            record.processedAt = record.processedAt ?? Date()
            updateStreakForInitialDailyResetOutcome(
                previousOutcome: previousOutcome,
                outcome: .engaged,
                userStats: userStats
            )
            transitions.append(DailyPenaltyRecordTransition(
                record: record,
                previousOutcome: previousOutcome,
                outcome: .engaged,
                previousPenaltyXP: previousPenaltyXP,
                penaltyXP: 0
            ))
        }
        if !transitions.isEmpty {
            recomputeCurrentStreakFromDailyResetRecords(
                canonicalRecords,
                userStats: userStats
            )
        }
        return transitions
    }
}
