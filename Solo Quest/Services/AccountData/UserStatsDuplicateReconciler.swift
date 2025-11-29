//
//  UserStatsDuplicateReconciler.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

enum UserStatsDuplicateReconciler {
    static func reconcile(
        context: NSManagedObjectContext,
        ownerIDs: Set<String>
    ) throws {
        guard !ownerIDs.isEmpty else { return }

        let request: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        request.predicate = NSPredicate(format: "ownerID IN %@", Array(ownerIDs))
        let stats = try context.fetch(request)
        let groups = Dictionary(grouping: stats.compactMap { stat -> UserStats? in
            guard stat.ownerID != nil else { return nil }
            return stat
        }, by: { $0.ownerID ?? "" })

        for statsWithOwner in groups.values {
            reconcileOwnerGroup(statsWithOwner, context: context)
        }
    }

    private static func reconcileOwnerGroup(
        _ stats: [UserStats],
        context: NSManagedObjectContext
    ) {
        guard !stats.isEmpty else { return }

        for stat in stats where stat.profileID == nil {
            stat.profileID = UUID()
        }
        let orderedStats = stats.sorted {
            ($0.profileID?.uuidString ?? "") < ($1.profileID?.uuidString ?? "")
        }
        guard let winner = orderedStats.first else { return }

        winner.totalXP = stats.map(\.totalXP).max() ?? winner.totalXP
        winner.level = stats.map(\.level).max() ?? winner.level
        winner.luckXP = stats.map(\.luckXP).max() ?? winner.luckXP
        winner.charismaXP = stats.map(\.charismaXP).max() ?? winner.charismaXP
        winner.strengthXP = stats.map(\.strengthXP).max() ?? winner.strengthXP
        winner.staminaXP = stats.map(\.staminaXP).max() ?? winner.staminaXP
        winner.resilienceXP = stats.map(\.resilienceXP).max() ?? winner.resilienceXP
        winner.intelligenceXP = stats.map(\.intelligenceXP).max() ?? winner.intelligenceXP
        winner.currentStreak = stats.map(\.currentStreak).max() ?? winner.currentStreak
        winner.sideQuestCredits = stats.map(\.sideQuestCredits).max() ?? winner.sideQuestCredits
        winner.dailyProSideQuestRemaining = stats.map(\.dailyProSideQuestRemaining).max()
            ?? winner.dailyProSideQuestRemaining
        winner.appliedDailyPenaltyXP = stats.map(\.appliedDailyPenaltyXP).max()
            ?? winner.appliedDailyPenaltyXP
        winner.rank = strongestRank(from: stats.compactMap(\.rank))
        winner.lastDailyGenerationDate = stats.compactMap(\.lastDailyGenerationDate).max()
        winner.lastQuestEngagementDate = stats.compactMap(\.lastQuestEngagementDate).max()
        winner.immunityEndDate = stats.compactMap(\.immunityEndDate).max()
        winner.lastProSideQuestResetDate = stats.compactMap(\.lastProSideQuestResetDate).max()
        winner.goals = stats.compactMap(\.goals).filter { !$0.isEmpty }.sorted().first

        for duplicate in orderedStats.dropFirst() {
            context.delete(duplicate)
        }
    }

    private static func strongestRank(from ranks: [String]) -> String {
        let rankOrder = ["E", "D", "C", "B", "A", "S"]
        return ranks.max { left, right in
            let leftIndex = rankOrder.firstIndex(of: left) ?? 0
            let rightIndex = rankOrder.firstIndex(of: right) ?? 0
            return leftIndex < rightIndex
        } ?? "E"
    }
}
