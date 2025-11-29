//
//  StoreKitService+PurchasesDelegate.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 08-25-2026
//

import Foundation
import RevenueCat

extension StoreKitService: PurchasesDelegate {
    nonisolated func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        let capturedRevenueCatIdentity = RevenueCatCallbackIdentity(
            revenueCatAppUserID: purchases.appUserID,
            isRevenueCatAnonymous: purchases.isAnonymous
        )
        Task { @MainActor [weak self] in
            _ = self?.applyDelegateCustomerInfo(
                customerInfo,
                capturedRevenueCatIdentity: capturedRevenueCatIdentity
            )
        }
    }
}
