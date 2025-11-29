//
//  DailyQuestDuplicateReconciler.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

enum DailyQuestDuplicateReconciler {
    static func reconcile(context: NSManagedObjectContext, scope: AccountScope) throws {
        let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        request.predicate = accountScopedPredicate(
            NSPredicate(format: "isSideQuest == NO AND logicalID != nil AND ownerID != nil"),
            scope: scope
        )
        let quests = try context.fetch(request)
        let groups = Dictionary(grouping: quests, by: { quest in
            "\(quest.ownerID ?? "")|\(quest.logicalID ?? "")"
        })

        for questsWithLogicalID in groups.values where questsWithLogicalID.count > 1 {
            try reconcileLogicalQuestGroup(questsWithLogicalID, context: context, scope: scope)
        }
    }

    private static func reconcileLogicalQuestGroup(
        _ quests: [QuestInstance],
        context: NSManagedObjectContext,
        scope: AccountScope
    ) throws {
        for quest in quests where quest.id == nil {
            quest.id = UUID()
        }
        let orderedQuests = quests.sorted { left, right in
            let leftStateRank = stateRank(left.state)
            let rightStateRank = stateRank(right.state)
            if leftStateRank != rightStateRank {
                return leftStateRank > rightStateRank
            }
            let leftFingerprint = DailyQuestContentFingerprint.make(for: left)
            let rightFingerprint = DailyQuestContentFingerprint.make(for: right)
            if leftFingerprint != rightFingerprint {
                return leftFingerprint < rightFingerprint
            }
            return (left.id?.uuidString ?? "") < (right.id?.uuidString ?? "")
        }
        guard let winner = orderedQuests.first, let winnerID = winner.id else { return }
        let stableOwnerID = winner.ownerID
        let stableLogicalID = winner.logicalID
        let stableGameDayID = winner.gameDayID
        let stableDailySlot = winner.dailySlot

        winner.dateAssigned = quests.compactMap(\.dateAssigned).min()
        winner.startTime = quests.compactMap(\.startTime).min()
        winner.activationTime = quests.compactMap(\.activationTime).min()
        winner.completionTime = quests.compactMap(\.completionTime).max()
        winner.expiryTime = quests.compactMap(\.expiryTime).max()
        winner.ownerID = stableOwnerID
        winner.logicalID = stableLogicalID
        winner.gameDayID = stableGameDayID
        winner.dailySlot = stableDailySlot

        let losers = Array(orderedQuests.dropFirst())
        let loserIDs = losers.compactMap(\.id)
        try reattachMediaItems(
            context: context,
            losers: losers,
            winner: winner
        )
        try repairActivityLogs(
            context: context,
            scope: scope,
            loserIDs: loserIDs,
            winnerID: winnerID
        )
        for loser in losers {
            context.delete(loser)
        }
    }

    private static func reattachMediaItems(
        context: NSManagedObjectContext,
        losers: [QuestInstance],
        winner: QuestInstance
    ) throws {
        guard !losers.isEmpty else { return }
        guard let winnerOwnerID = winner.ownerID else { return }

        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.predicate = NSPredicate(
            format: "quest IN %@ AND ownerID == %@",
            losers,
            winnerOwnerID
        )
        for mediaItem in try context.fetch(request) {
            mediaItem.quest = winner
        }
    }

    private static func repairActivityLogs(
        context: NSManagedObjectContext,
        scope: AccountScope,
        loserIDs: [UUID],
        winnerID: UUID
    ) throws {
        guard !loserIDs.isEmpty else { return }

        let request: NSFetchRequest<ActivityLog> = ActivityLog.fetchRequest()
        request.predicate = accountScopedPredicate(
            NSPredicate(format: "questInstanceId IN %@", loserIDs),
            scope: scope
        )
        for activityLog in try context.fetch(request) {
            activityLog.questInstanceId = winnerID
        }
    }

    private static func stateRank(_ rawState: String?) -> Int {
        switch rawState {
        case "completed":
            return 5
        case "failed":
            return 4
        case "active":
            return 3
        case "locked":
            return 2
        case "available":
            return 1
        default:
            return 0
        }
    }
}
