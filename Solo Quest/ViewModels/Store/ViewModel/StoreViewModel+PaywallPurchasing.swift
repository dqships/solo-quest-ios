//
//  StoreViewModel+PaywallPurchasing.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//  Modified by DaQuan Louden on 08-25-2026
//

import Foundation
import RevenueCat

extension StoreViewModel {
    func handlePaywallSelected(_ paywallType: StorePaywallType, source: String = PaywallSource.store.rawValue) {
        activePaywallSource = source
        activePaywallCustomerInfoToken = storeKit.captureExternalCustomerInfoToken()
        analytics.track(event: "store_paywall_selected", properties: [
            "source": source,
            "offering_id": paywallType.offeringIdentifier,
            "paywall_type": paywallType.rawValue
        ])
    }

    func handlePaywallViewed(_ paywallType: StorePaywallType) {
        analytics.trackPaywallViewed(source: activePaywallSource, context: [
            "offering_id": paywallType.offeringIdentifier,
            "paywall_type": paywallType.rawValue,
            "legacy_source": paywallType.analyticsSource
        ])
    }

    func handlePaywallPurchaseStarted(package: Package, paywallType: StorePaywallType) {
        activePaywallCustomerInfoToken = storeKit.captureExternalCustomerInfoToken()
        activePaywallProductId = package.storeProduct.productIdentifier

        let product = product(for: package.storeProduct.productIdentifier)
        let name = product?.title ?? package.storeProduct.localizedTitle
        let productType = product.map { String(describing: $0.type) } ?? paywallType.analyticsProductType
        let price = package.storeProduct.localizedPriceString

        analytics.trackStoreProductSelected(
            id: package.storeProduct.productIdentifier,
            name: name,
            type: productType
        )
        analytics.trackProductTapped(
            id: package.storeProduct.productIdentifier,
            name: name,
            type: productType,
            price: price,
            source: activePaywallSource
        )
        analytics.trackPurchaseStarted(
            id: package.storeProduct.productIdentifier,
            name: name,
            type: productType,
            price: price,
            source: activePaywallSource
        )
    }

    func handlePaywallPurchaseCompleted(
        transaction: StoreTransaction?,
        customerInfo: CustomerInfo,
        paywallType: StorePaywallType
    ) {
        guard let token = activePaywallCustomerInfoToken,
              storeKit.applyCustomerInfo(customerInfo, token: token) else {
            clearPaywallCustomerInfoToken()
            activePaywallProductId = nil
            return
        }

        if let transactionIdentifier = transaction?.transactionIdentifier {
            guard !processedPaywallTransactionIds.contains(transactionIdentifier) else {
                activePaywallProductId = nil
                clearPaywallCustomerInfoToken()
                return
            }
            processedPaywallTransactionIds.insert(transactionIdentifier)
        }

        let productId = transaction?.productIdentifier ?? activePaywallProductId
        let product = product(for: productId)
        let purchaseId = productId ?? paywallType.offeringIdentifier
        let name = product?.title ?? paywallType.analyticsName
        let productType = product.map { String(describing: $0.type) } ?? paywallType.analyticsProductType
        let price = product?.price ?? String(localized: "unknown")
        let isProActive = customerInfo.entitlements["pro"]?.isActive == true

        analytics.trackPurchaseSucceededRevenueCat(
            id: purchaseId,
            name: name,
            type: productType,
            price: price,
            source: activePaywallSource,
            isProActive: isProActive
        )
        analytics.trackPurchaseCompleted(
            id: purchaseId,
            name: name,
            type: productType,
            price: price
        )

        if product?.type == .subscription {
            analytics.trackSubscriptionStartedRevenueCat(
                id: purchaseId,
                name: name,
                price: price,
                source: activePaywallSource
            )
        }

        if isProActive, let productId = customerInfo.entitlements["pro"]?.productIdentifier {
            analytics.trackEntitlementActive(
                entitlement: "pro",
                productId: productId,
                source: activePaywallSource
            )
        }

        if let product, product.type == .reroll {
            Task { @MainActor in
                await handlePostPurchase(product)
                loadUserData()
            }
        } else {
            loadUserData()
        }

        activePaywallProductId = nil
        clearPaywallCustomerInfoToken()
    }

    func handlePaywallPurchaseCancelled(_ paywallType: StorePaywallType) {
        let product = product(for: activePaywallProductId)
        analytics.trackPurchaseCancelled(
            id: activePaywallProductId ?? paywallType.offeringIdentifier,
            name: product?.title ?? paywallType.analyticsName,
            type: product.map { String(describing: $0.type) } ?? paywallType.analyticsProductType,
            price: product?.price ?? String(localized: "unknown"),
            source: activePaywallSource
        )
        activePaywallProductId = nil
        clearPaywallCustomerInfoToken()
    }

    func handlePaywallPurchaseFailed(error: NSError, paywallType: StorePaywallType) {
        let product = product(for: activePaywallProductId)
        analytics.trackPurchaseFailed(
            id: activePaywallProductId ?? paywallType.offeringIdentifier,
            name: product?.title ?? paywallType.analyticsName,
            type: product.map { String(describing: $0.type) } ?? paywallType.analyticsProductType,
            price: product?.price ?? String(localized: "unknown"),
            source: activePaywallSource,
            errorDescription: error.localizedDescription
        )
        activePaywallProductId = nil
        clearPaywallCustomerInfoToken()
    }

    func handlePaywallRestoreCompleted(customerInfo: CustomerInfo, paywallType: StorePaywallType) {
        guard let token = activePaywallCustomerInfoToken,
              storeKit.applyCustomerInfo(customerInfo, token: token) else {
            clearPaywallCustomerInfoToken()
            return
        }

        if let productId = customerInfo.entitlements["pro"]?.productIdentifier,
           customerInfo.entitlements["pro"]?.isActive == true {
            analytics.trackEntitlementActive(
                entitlement: "pro",
                productId: productId,
                source: activePaywallSource
            )
        }

        loadUserData()
        clearPaywallCustomerInfoToken()
    }

    func handlePaywallRestoreFailed(error: NSError, paywallType: StorePaywallType) {
        analytics.track(event: "purchase_restore_failed", properties: [
            "source": activePaywallSource,
            "offering_id": paywallType.offeringIdentifier,
            "error_description": error.localizedDescription
        ])
        clearPaywallCustomerInfoToken()
    }

    func handlePaywallDismissed() {
        clearPaywallCustomerInfoToken()
    }

    private func clearPaywallCustomerInfoToken() {
        activePaywallCustomerInfoToken = nil
    }

    private func product(for productId: String?) -> StoreProduct? {
        guard let productId else { return nil }
        return (subscriptions + rerollPacks).first { product in
            product.productId == productId
        }
    }
}
