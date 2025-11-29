//
//  AnalyticsManager+Monetization.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import Foundation

extension AnalyticsManager {
    func trackPaywallViewed(source: String, context: [String: Any] = [:]) {
        var properties = context
        properties["source"] = source
        track(event: "paywall_viewed", properties: properties)
    }

    func trackProductTapped(
        id: String,
        name: String,
        type: String,
        price: String,
        source: String
    ) {
        track(event: "product_tapped", properties: monetizationProperties(
            id: id,
            name: name,
            type: type,
            price: price,
            source: source
        ))
    }

    func trackPurchaseStarted(
        id: String,
        name: String,
        type: String,
        price: String,
        source: String
    ) {
        track(event: "purchase_started", properties: monetizationProperties(
            id: id,
            name: name,
            type: type,
            price: price,
            source: source
        ))
    }

    func trackPurchaseCancelled(
        id: String,
        name: String,
        type: String,
        price: String,
        source: String
    ) {
        track(event: "purchase_cancelled", properties: monetizationProperties(
            id: id,
            name: name,
            type: type,
            price: price,
            source: source
        ))
    }

    func trackPurchaseFailed(
        id: String,
        name: String,
        type: String,
        price: String,
        source: String,
        errorDescription: String
    ) {
        var properties = monetizationProperties(
            id: id,
            name: name,
            type: type,
            price: price,
            source: source
        )
        properties["error_description"] = errorDescription
        track(event: "purchase_failed", properties: properties)
    }

    func trackPurchaseSucceededRevenueCat(
        id: String,
        name: String,
        type: String,
        price: String,
        source: String,
        isProActive: Bool
    ) {
        var properties = monetizationProperties(
            id: id,
            name: name,
            type: type,
            price: price,
            source: source
        )
        properties["is_pro_active"] = isProActive
        track(event: "purchase_succeeded_revenuecat", properties: properties)
    }

    func trackTrialStartedRevenueCat(
        id: String,
        name: String,
        price: String,
        source: String
    ) {
        track(event: "trial_started_revenuecat", properties: monetizationProperties(
            id: id,
            name: name,
            type: "subscription",
            price: price,
            source: source
        ))
    }

    func trackSubscriptionStartedRevenueCat(
        id: String,
        name: String,
        price: String,
        source: String
    ) {
        track(event: "subscription_started_revenuecat", properties: monetizationProperties(
            id: id,
            name: name,
            type: "subscription",
            price: price,
            source: source
        ))
    }

    func trackEntitlementActive(
        entitlement: String,
        productId: String,
        source: String
    ) {
        track(event: "entitlement_active", properties: [
            "entitlement": entitlement,
            "product_id": productId,
            "source": source
        ])
    }

    private func monetizationProperties(
        id: String,
        name: String,
        type: String,
        price: String,
        source: String
    ) -> [String: Any] {
        [
            "product_id": id,
            "product_name": name,
            "product_type": type,
            "price": price,
            "source": source
        ]
    }
}
