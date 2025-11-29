//
//  QuestEngine+DailyQuota.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-24-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func gameDayBounds(containing date: Date = Date()) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        let localDay = calendar.startOfDay(for: date)
        guard let boundaryToday = gameDayBoundary(for: localDay, calendar: calendar) else { return nil }
        let gameDayDate = date < boundaryToday
            ? calendar.date(byAdding: .day, value: -1, to: localDay)
            : localDay

        guard let gameDayDate,
              let start = gameDayBoundary(for: gameDayDate, calendar: calendar),
              let nextLocalDate = calendar.date(byAdding: .day, value: 1, to: gameDayDate),
              let end = gameDayBoundary(for: nextLocalDate, calendar: calendar) else {
            return nil
        }

        return (start, end)
    }

    func dailyQuestLimit() -> Int {
        max(0, gameData?.config.dailyQuestRules.questsPerDay ?? 3)
    }

    func prepareDailyQuestGeneration(
        context: NSManagedObjectContext,
        gameDay: (start: Date, end: Date)
    ) -> DailyQuestGenerationContext? {
        let limit = dailyQuestLimit()
        let scope = accountScopeProvider.activeScope
        let initialContext = DailyQuestGenerationContextFactory.make(
            ownerID: scope.writeOwnerID,
            gameDayStart: gameDay.start,
            slots: [],
            calendar: .current
        )
        let currentQuests = fetchQuestInstances(
            context: context,
            start: gameDay.start,
            end: gameDay.end,
            isSideQuest: false
        )
        backfillDailyQuestMetadata(
            quests: currentQuests,
            gameDayID: initialContext.gameDayID,
            limit: limit
        )
        do {
            try DailyQuestDuplicateReconciler.reconcile(context: context, scope: scope)
        } catch {
            print("⚠️ QuestEngine: Failed to canonicalize daily quests: \(error)")
            return nil
        }
        let canonicalQuests = fetchQuestInstances(
            context: context,
            start: gameDay.start,
            end: gameDay.end,
            isSideQuest: false
        )
        let slots = missingDailyQuestSlots(quests: canonicalQuests, limit: limit)
        return DailyQuestGenerationContextFactory.make(
            ownerID: scope.writeOwnerID,
            gameDayStart: gameDay.start,
            slots: slots,
            calendar: .current
        )
    }

    func fetchQuestInstances(
        context: NSManagedObjectContext,
        start: Date,
        end: Date,
        isSideQuest: Bool? = nil
    ) -> [QuestInstance] {
        let request: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: true)]

        var predicates: [NSPredicate] = [
            NSPredicate(
                format: "dateAssigned >= %@ AND dateAssigned < %@",
                start as NSDate,
                end as NSDate
            )
        ]

        if let isSideQuest {
            predicates.append(NSPredicate(format: "isSideQuest == %@", NSNumber(value: isSideQuest)))
        }

        request.predicate = accountScopedPredicate(
            NSCompoundPredicate(andPredicateWithSubpredicates: predicates),
            scope: accountScopeProvider.activeScope
        )

        do {
            return try context.fetch(request)
        } catch {
            print("❌ QuestEngine: Failed to fetch daily quests: \(error)")
            return []
        }
    }

    func finishedDailyQuestCount(
        context: NSManagedObjectContext,
        start: Date,
        end: Date,
        excluding quest: QuestInstance? = nil
    ) -> Int {
        fetchQuestInstances(context: context, start: start, end: end, isSideQuest: false).filter { instance in
            if let quest, instance.objectID == quest.objectID {
                return false
            }

            return instance.state == "completed" || instance.state == "failed"
        }.count
    }

    @discardableResult
    func reconcileCurrentDailyQuestQuota(context: NSManagedObjectContext) -> Bool {
        guard let gameDay = gameDayBounds() else { return false }
        guard let dailyGenerationContext = prepareDailyQuestGeneration(
            context: context,
            gameDay: gameDay
        ) else {
            return false
        }

        let quests = fetchQuestInstances(
            context: context,
            start: gameDay.start,
            end: gameDay.end,
            isSideQuest: false
        )
        let limit = dailyQuestLimit()
        if !dailyGenerationContext.slots.isEmpty {
            let userStats = fetchOrCreateUserStats(context: context)
            return createRandomQuests(
                context: context,
                count: dailyGenerationContext.slots.count,
                isSideQuest: false,
                userLevel: Int(userStats.level),
                dailyGenerationContext: dailyGenerationContext
            ) > 0
        }
        guard quests.count > limit else { return false }

        let orderedQuests = quests.sorted { lhs, rhs in
            let lhsPriority = dailyQuotaRetentionPriority(for: lhs)
            let rhsPriority = dailyQuotaRetentionPriority(for: rhs)

            if lhsPriority != rhsPriority {
                return lhsPriority < rhsPriority
            }

            return (lhs.dateAssigned ?? .distantPast) < (rhs.dateAssigned ?? .distantPast)
        }

        let retainedIDs = Set(orderedQuests.prefix(limit).map(\.objectID))
        var didDeleteQuest = false

        for quest in orderedQuests where !retainedIDs.contains(quest.objectID) {
            guard quest.state != "completed", quest.state != "failed" else {
                continue
            }

            context.delete(quest)
            didDeleteQuest = true
        }

        return didDeleteQuest
    }

    private func dailyQuotaRetentionPriority(for quest: QuestInstance) -> Int {
        switch quest.state {
        case "completed", "failed":
            return 0
        case "active", "locked":
            return 1
        case "available":
            return 2
        default:
            return 3
        }
    }
}
