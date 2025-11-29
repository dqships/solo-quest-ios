//
//  FirstWeekRecapService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import CoreData
import Foundation

@MainActor
final class FirstWeekRecapService {
    private let persistence: PersistenceController
    private let lifecycle: PlayerLifecycleService
    private let accountScopeProvider: AccountScopeProvider

    init(
        persistence: PersistenceController,
        lifecycle: PlayerLifecycleService,
        accountScopeProvider: AccountScopeProvider
    ) {
        self.persistence = persistence
        self.lifecycle = lifecycle
        self.accountScopeProvider = accountScopeProvider
    }

    func makeRecap() -> FirstWeekRecap? {
        guard lifecycle.activeDaysLifetime > 0 else { return nil }
        let context = persistence.container.viewContext
        let statsRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        statsRequest.fetchLimit = 1
        statsRequest.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)
        statsRequest.sortDescriptors = accountUserStatsSortDescriptors()
        guard let stats = try? context.fetch(statsRequest).first else { return nil }
        let start = lifecycle.usableStartedAt ?? .distantPast

        let questRequest: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        questRequest.predicate = accountScopedPredicate(
            NSPredicate(format: "state == %@ AND completionTime >= %@", "completed", start as NSDate),
            scope: accountScopeProvider.activeScope
        )

        let activityRequest: NSFetchRequest<ActivityLog> = ActivityLog.fetchRequest()
        activityRequest.predicate = accountScopedPredicate(
            NSPredicate(format: "date >= %@ AND xpDelta > 0", start as NSDate),
            scope: accountScopeProvider.activeScope
        )

        let mediaRequest: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        mediaRequest.predicate = accountScopedPredicate(
            NSPredicate(format: "createdAt >= %@", start as NSDate),
            scope: accountScopeProvider.activeScope
        )


        let strongest = stats.strongestStat
        return FirstWeekRecap(
            questsCompleted: (try? context.count(for: questRequest)) ?? 0,
            activeDays: lifecycle.activeDaysLifetime,
            xpEarned: ((try? context.fetch(activityRequest)) ?? []).reduce(0) { $0 + Int($1.xpDelta) },
            strongestStat: strongest.name,
            strongestStatXP: Int(strongest.xp),
            level: Int(stats.level),
            rank: stats.rank ?? "E",
            memoriesCreated: (try? context.count(for: mediaRequest)) ?? 0
        )
    }
}
