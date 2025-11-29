//
//  StatsViewModel+CoreData.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Foundation

extension StatsViewModel {
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

        let activityRequest: NSFetchRequest<ActivityLog> = ActivityLog.fetchRequest()
        activityRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        activityRequest.fetchLimit = 20
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
            try activityFRC?.performFetch()
            updateFromCoreData()
        } catch {
            print("❌ StatsViewModel: Failed to fetch Core Data: \(error)")
        }
    }

    func updateFromCoreData() {
        guard let stats = statsFRC?.fetchedObjects?.first else {
            user = UserProfile.empty()
            return
        }

        let logs = activityFRC?.fetchedObjects?.map {
            ActivityLogItemMapper.make(from: $0)
        } ?? []

        user = UserProfileMapper.make(stats: stats, activityLog: logs)

        let progressData = questEngine.getLevelProgress(totalXP: stats.totalXP)
        levelProgress = progressData.progress
        currentLevelXP = Int(progressData.currentLevelXP)
        nextLevelXP = Int(progressData.nextLevelXP)

        checkForLevelUp(currentLevel: Int(stats.level))
        checkForRankUp(currentRank: stats.rank ?? "E")
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateFromCoreData()
    }
}
