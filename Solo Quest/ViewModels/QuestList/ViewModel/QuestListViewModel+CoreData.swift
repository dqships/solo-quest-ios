//
//  QuestListViewModel+CoreData.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Foundation

extension QuestListViewModel {
    func setupCoreData() {
        let context = persistence.container.viewContext

        let statsRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        statsRequest.sortDescriptors = accountUserStatsSortDescriptors()
        statsRequest.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)

        statsFRC = NSFetchedResultsController(
            fetchRequest: statsRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        statsFRC?.delegate = self

        let questsRequest: NSFetchRequest<QuestInstance> = QuestInstance.fetchRequest()
        questsRequest.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]

        let gameDay = currentGameDayBounds()
        questsRequest.predicate = accountScopedPredicate(NSPredicate(
            format: "dateAssigned >= %@ AND dateAssigned < %@",
            gameDay.start as NSDate,
            gameDay.end as NSDate
        ), scope: accountScopeProvider.activeScope)

        questsFRC = NSFetchedResultsController(
            fetchRequest: questsRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        questsFRC?.delegate = self

        let activityRequest: NSFetchRequest<ActivityLog> = ActivityLog.fetchRequest()
        activityRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        activityRequest.fetchLimit = activityFetchLimit
        activityRequest.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)

        activityFRC = NSFetchedResultsController(
            fetchRequest: activityRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        activityFRC?.delegate = self

        do {
            try statsFRC?.performFetch()
            try questsFRC?.performFetch()
            try activityFRC?.performFetch()
            updateFromCoreData()
        } catch {
            print("❌ ViewModel: Failed to fetch Core Data: \(error)")
        }
    }

    func updateFromCoreData() {
        if persistence.isReadyForDailyReset {
            questEngine.updateQuestStates()

            if let context = questsFRC?.managedObjectContext,
               questEngine.reconcileCurrentDailyQuestQuota(context: context) {
                do {
                    try context.save()
                    try questsFRC?.performFetch()
                } catch {
                    print("❌ ViewModel: Failed to reconcile daily quest quota: \(error)")
                }
            }
        }

        let logs = activityFRC?.fetchedObjects?.map {
            ActivityLogItemMapper.make(from: $0)
        } ?? []

        if let stats = statsFRC?.fetchedObjects?.first {
            user = UserProfileMapper.make(stats: stats, activityLog: logs)

            let progressData = questEngine.getLevelProgress(totalXP: stats.totalXP)
            levelProgress = progressData.progress
            currentLevelXP = Int(progressData.currentLevelXP)
            nextLevelXP = Int(progressData.nextLevelXP)
        }

        if let instances = questsFRC?.fetchedObjects {
            let filtered = instances.filter { !$0.isSideQuest }
            dailyQuests = filtered.sorted { q1, q2 in
                let starter1 = starterPriority(for: q1)
                let starter2 = starterPriority(for: q2)
                if starter1 != starter2 {
                    return starter1 < starter2
                }

                let s1 = sortScore(for: q1.state)
                let s2 = sortScore(for: q2.state)

                if s1 != s2 {
                    return s1 < s2
                }

                return (q1.dateAssigned ?? Date()) > (q2.dateAssigned ?? Date())
            }
        }

        if let stats = statsFRC?.fetchedObjects?.first {
            let progressData = questEngine.getLevelProgress(totalXP: stats.totalXP)
            let shortestMinutes = dailyQuests.filter { $0.state == "available" }.compactMap { quest in
                quest.questTemplateId.flatMap { questEngine.getTemplate(id: $0) }.map {
                    questEngine.getDuration(size: $0.size).minMinutes
                }
            }.min()
            retentionNotifications.refreshDailyReminder(
                shortestQuestMinutes: shortestMinutes,
                lastEngagementDate: stats.lastQuestEngagementDate,
                levelXPRemaining: max(0, Int(progressData.nextLevelXP - progressData.currentLevelXP))
            )
            trackQuestSeenIfNeeded(stats: stats)
            trackFirstQuestSeenIfNeeded(stats: stats)
            trackMeaningfulActiveDayIfNeeded(stats: stats)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateFromCoreData()
    }
}
