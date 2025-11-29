//
//  QuestEngine+ClosedGameDayPenalty.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func reconcileClosedGameDay(
        context: NSManagedObjectContext,
        userStats: UserStats,
        gameDay: (start: Date, end: Date),
        entitlementDecision: PenaltyEntitlementDecision
    ) -> DailyPenaltyRecordTransition? {
        let scope = accountScopeProvider.activeScope
        let gameDayID = GameDayIdentifier.make(gameDayStart: gameDay.start, calendar: .current)

        do {
            let existingRecords = try fetchDailyResetRecords(context: context, scope: scope)
            DailyResetRecordCanonicalizer.canonicalize(records: existingRecords, context: context)

            let record = try DailyResetRecordFactory.upsert(
                context: context,
                scope: scope,
                gameDayID: gameDayID,
                gameDayStart: gameDay.start,
                gameDayEnd: gameDay.end
            )
            let previousOutcome = DailyResetOutcomeValue(rawValue: record.outcome ?? "") ?? .pending
            let previousPenaltyXP = max(0, record.penaltyXP)
            let quests = fetchQuestInstances(
                context: context,
                start: gameDay.start,
                end: gameDay.end,
                isSideQuest: false
            )
            let trackedEngagement = userStats.lastQuestEngagementDate.map {
                $0 >= gameDay.start && $0 < gameDay.end
            } ?? false
            let isEngaged = trackedEngagement || quests.contains { $0.state != "available" }

            if isEngaged {
                record.outcome = DailyResetOutcomeValue.engaged.rawValue
                record.penaltyXP = 0
            } else if entitlementDecision == .pro, previousOutcome != .engaged {
                record.outcome = DailyResetOutcomeValue.protected.rawValue
                record.penaltyXP = 0
            } else if previousOutcome == .pending {
                let isNoviceProtected = newPlayerProtection.isActive()
                if isNoviceProtected || gameData?.config.dailyQuestRules.applySkipPenalty != true {
                    record.outcome = DailyResetOutcomeValue.protected.rawValue
                    record.penaltyXP = 0
                } else {
                    record.outcome = DailyResetOutcomeValue.penalized.rawValue
                    record.penaltyXP = cappedDailyPenalty(
                        context: context,
                        userStats: userStats,
                        record: record,
                        nominalPenaltyXP: dailySkipPenalty(for: quests)
                    )
                }
            }

            let outcome = DailyResetOutcomeValue(rawValue: record.outcome ?? "") ?? .pending
            if outcome != .pending {
                record.processedAt = record.processedAt ?? Date()
            }
            updateStreakForInitialDailyResetOutcome(
                previousOutcome: previousOutcome,
                outcome: outcome,
                userStats: userStats
            )

            let penaltyXP = max(0, record.penaltyXP)
            guard previousOutcome != outcome || previousPenaltyXP != penaltyXP else { return nil }
            return DailyPenaltyRecordTransition(
                record: record,
                previousOutcome: previousOutcome,
                outcome: outcome,
                previousPenaltyXP: previousPenaltyXP,
                penaltyXP: penaltyXP
            )
        } catch {
            print("⚠️ QuestEngine: Failed to reconcile closed game day: \(error)")
            return nil
        }
    }

    private func cappedDailyPenalty(
        context: NSManagedObjectContext,
        userStats: UserStats,
        record: DailyResetRecord,
        nominalPenaltyXP: Int64
    ) -> Int64 {
        let scope = accountScopeProvider.activeScope
        let records = (try? fetchDailyResetRecords(context: context, scope: scope)) ?? []
        DailyResetRecordCanonicalizer.canonicalize(records: records, context: context)
        let canonicalRecords = (try? fetchDailyResetRecords(context: context, scope: scope)) ?? []
        let storedPenaltyXP = canonicalRecords.reduce(Int64.zero) { partialResult, existingRecord in
            guard existingRecord.objectID != record.objectID,
                  DailyResetOutcomeValue(rawValue: existingRecord.outcome ?? "") == .penalized else {
                return partialResult
            }
            let (sum, overflow) = partialResult.addingReportingOverflow(max(0, existingRecord.penaltyXP))
            return overflow ? Int64.max : sum
        }
        let (baseWithOverflow, didOverflow) = userStats.totalXP.addingReportingOverflow(
            max(0, userStats.appliedDailyPenaltyXP)
        )
        let baseXP = didOverflow ? Int64.max : max(0, baseWithOverflow)
        let minimumXP = Int64(gameData?.config.penalties.minTotalXP ?? 0)
        let availableXP = max(0, baseXP - minimumXP - storedPenaltyXP)
        return min(max(0, nominalPenaltyXP), availableXP)
    }

    func updateStreakForInitialDailyResetOutcome(
        previousOutcome: DailyResetOutcomeValue,
        outcome: DailyResetOutcomeValue,
        userStats: UserStats
    ) {
        guard previousOutcome == .pending, outcome != .pending else { return }

        if outcome == .engaged {
            if userStats.currentStreak < Int16.max {
                userStats.currentStreak += 1
            }
        } else {
            userStats.currentStreak = 0
        }
    }
}
