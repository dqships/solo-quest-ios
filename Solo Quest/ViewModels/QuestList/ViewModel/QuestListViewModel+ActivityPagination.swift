//
//  QuestListViewModel+ActivityPagination.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Foundation

extension QuestListViewModel {
    func loadMoreActivity() {
        activityFetchLimit += 20
        activityFRC?.fetchRequest.fetchLimit = activityFetchLimit
        do {
            try activityFRC?.performFetch()
            updateFromCoreData()
        } catch {
            print("❌ Failed to load more activity: \(error)")
        }
    }
}
