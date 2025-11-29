//
//  QuestEngine+DailyPenaltyAnalytics.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func trackDailyPenaltyTransitions(
        _ transitions: [DailyPenaltyRecordTransition],
        appliedDelta: Int64,
        context: NSManagedObjectContext,
        userStats: UserStats
    ) {
        for transition in transitions {
            guard let resetLogicalID = transition.record.logicalID else { continue }

            if transition.previousOutcome != .protected && transition.outcome == .protected {
                trackDailyPenaltyEvent(
                    event: "daily_skip_penalty_prevented",
                    resetLogicalID: resetLogicalID,
                    eventType: "prevented",
                    context: context,
                    userStats: userStats,
                    penaltyXP: 0
                )
            }

            if transition.previousOutcome != .penalized,
               transition.outcome == .penalized,
               transition.penaltyXP > transition.previousPenaltyXP,
               appliedDelta > 0 {
                trackDailyPenaltyEvent(
                    event: "daily_skip_penalty_applied",
                    resetLogicalID: resetLogicalID,
                    eventType: "applied",
                    context: context,
                    userStats: userStats,
                    penaltyXP: transition.penaltyXP - transition.previousPenaltyXP
                )
            }

            if transition.previousPenaltyXP > transition.penaltyXP,
               appliedDelta < 0 {
                trackDailyPenaltyEvent(
                    event: "daily_skip_penalty_refunded",
                    resetLogicalID: resetLogicalID,
                    eventType: "refund",
                    context: context,
                    userStats: userStats,
                    penaltyXP: transition.previousPenaltyXP - transition.penaltyXP
                )
            }
        }
    }

    private func trackDailyPenaltyEvent(
        event: String,
        resetLogicalID: String,
        eventType: String,
        context: NSManagedObjectContext,
        userStats: UserStats,
        penaltyXP: Int64
    ) {
        analytics.track(
            event: event,
            properties: retentionAnalyticsProperties(context: context).merging([
                "$insert_id": "\(resetLogicalID)|\(eventType)",
                "source": "daily_reset",
                "xp_lost": Int(penaltyXP),
                "user_level": Int(userStats.level),
                "user_rank": userStats.rank ?? "E",
                "user_total_xp": Int(userStats.totalXP),
                "user_current_streak": Int(userStats.currentStreak)
            ], uniquingKeysWith: { _, new in new })
        )
    }
}
