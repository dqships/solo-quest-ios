//
//  StoreViewModel+UserData.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension StoreViewModel {
    func loadUserData() {
        let context = persistence.container.viewContext
        let request: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        request.fetchLimit = 1
        request.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)
        request.sortDescriptors = accountUserStatsSortDescriptors()

        do {
            if let stats = try context.fetch(request).first {
                rerollBalance = Int(stats.sideQuestCredits)
            }
        } catch {
            print("Failed to load user stats: \(error)")
        }
    }
}
