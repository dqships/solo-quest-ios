//
//  RevenueCatCustomerInfoAnalyticsProperties.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import Foundation
import RevenueCat

enum RevenueCatCustomerInfoAnalyticsProperties {
    static func make(from customerInfo: CustomerInfo) -> [String: Any] {
        let pro = customerInfo.entitlements["pro"]

        return [
            "revenuecat_original_app_user_id": customerInfo.originalAppUserId,
            "revenuecat_first_seen_at": AnalyticsDateFormatter.string(from: customerInfo.firstSeen),
            "revenuecat_request_date": AnalyticsDateFormatter.string(from: customerInfo.requestDate),
            "is_pro": pro?.isActive == true,
            "pro_product_id": pro?.productIdentifier ?? "none",
            "pro_period_type": pro.map { String(describing: $0.periodType) } ?? "none",
            "pro_store": pro.map { String(describing: $0.store) } ?? "none",
            "pro_will_renew": pro?.willRenew ?? false,
            "pro_expires_at": pro?.expirationDate.map(AnalyticsDateFormatter.string(from:)) ?? "none",
            "active_subscription_count": customerInfo.activeSubscriptions.count,
            "active_subscription_ids": Array(customerInfo.activeSubscriptions).sorted(),
            "purchased_product_count": customerInfo.allPurchasedProductIdentifiers.count,
            "purchased_product_ids": Array(customerInfo.allPurchasedProductIdentifiers).sorted()
        ]
    }
}
