//
//  StoreViewModel+PostPurchase.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension StoreViewModel {
    func handlePostPurchase(_ product: StoreProduct) async {
        let context = persistence.container.viewContext
        let request: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        request.fetchLimit = 1
        request.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)
        request.sortDescriptors = accountUserStatsSortDescriptors()

        guard let stats = try? context.fetch(request).first else { return }

        switch product.type {
        case .reroll:
            if product.productId.contains("100") {
                stats.sideQuestCredits += 100
            } else if product.productId.contains("50") {
                stats.sideQuestCredits += 50
            } else if product.productId.contains("10") {
                stats.sideQuestCredits += 10
            }

        case .subscription:
            break
        }

        try? context.save()
    }
}
