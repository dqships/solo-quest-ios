//
//  StoreViewModel+Purchasing.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import RevenueCat

extension StoreViewModel {
    func purchase(_ product: StoreProduct) {
        let source = "store_tab"
        let productType = String(describing: product.type)

        analytics.trackStoreProductSelected(
            id: product.productId,
            name: product.title,
            type: productType
        )
        analytics.trackProductTapped(
            id: product.productId,
            name: product.title,
            type: productType,
            price: product.price,
            source: source
        )
        analytics.trackPurchaseStarted(
            id: product.productId,
            name: product.title,
            type: productType,
            price: product.price,
            source: source
        )

        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                guard let offerings = try? await Purchases.shared.offerings() else {
                    print("Failed to fetch offerings")
                    analytics.trackPurchaseFailed(
                        id: product.productId,
                        name: product.title,
                        type: productType,
                        price: product.price,
                        source: source,
                        errorDescription: "Failed to fetch offerings"
                    )
                    return
                }

                let offeringIdentifier: String

                switch product.type {
                case .subscription:
                    offeringIdentifier = RevenueCatOfferingID.subscription
                case .reroll:
                    offeringIdentifier = RevenueCatOfferingID.rerolls
                }

                guard let offering = offerings.offering(identifier: offeringIdentifier) else {
                    print("Offering not found: \(offeringIdentifier)")
                    errorMessage = String(localized: "Product options are unavailable")
                    analytics.trackPurchaseFailed(
                        id: product.productId,
                        name: product.title,
                        type: productType,
                        price: product.price,
                        source: source,
                        errorDescription: "Offering not found"
                    )
                    return
                }

                let availablePackages = offering.availablePackages

                guard let package = availablePackages.first(where: { $0.storeProduct.productIdentifier == product.productId }) else {
                    print("Product not found in offerings: \(product.productId)")
                    errorMessage = String(localized: "Product not available")
                    analytics.trackPurchaseFailed(
                        id: product.productId,
                        name: product.title,
                        type: productType,
                        price: product.price,
                        source: source,
                        errorDescription: "Product not found in offerings"
                    )
                    return
                }

                let result = try await storeKit.purchase(package: package)

                guard !result.userCancelled else {
                    print("Purchase cancelled by user")
                    analytics.trackPurchaseCancelled(
                        id: product.productId,
                        name: product.title,
                        type: productType,
                        price: product.price,
                        source: source
                    )
                    return
                }

                guard result.transaction != nil else {
                    print("Purchase did not return a valid transaction")
                    errorMessage = "Purchase could not be completed"
                    analytics.trackPurchaseFailed(
                        id: product.productId,
                        name: product.title,
                        type: productType,
                        price: product.price,
                        source: source,
                        errorDescription: "Purchase did not return a valid transaction"
                    )
                    return
                }

                let isProActive = result.customerInfo.entitlements["pro"]?.isActive == true
                analytics.trackPurchaseSucceededRevenueCat(
                    id: product.productId,
                    name: product.title,
                    type: productType,
                    price: product.price,
                    source: source,
                    isProActive: isProActive
                )
                analytics.trackPurchaseCompleted(
                    id: product.productId,
                    name: product.title,
                    type: productType,
                    price: product.price
                )

                if product.type == .subscription {
                    analytics.trackSubscriptionStartedRevenueCat(
                        id: product.productId,
                        name: product.title,
                        price: product.price,
                        source: source
                    )
                }

                if isProActive, let productId = result.customerInfo.entitlements["pro"]?.productIdentifier {
                    analytics.trackEntitlementActive(
                        entitlement: "pro",
                        productId: productId,
                        source: source
                    )
                }

                await handlePostPurchase(product)
                loadUserData()
            } catch {
                print("Purchase failed: \(error)")
                errorMessage = error.localizedDescription
                analytics.trackPurchaseFailed(
                    id: product.productId,
                    name: product.title,
                    type: productType,
                    price: product.price,
                    source: source,
                    errorDescription: error.localizedDescription
                )
            }
        }
    }
}
