//
//  StoreKitService+Analytics.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import Foundation
import RevenueCat

extension StoreKitService {
    func syncAnalyticsCustomerInfo(_ info: CustomerInfo) {
        guard let clerkUserId = AnalyticsIdentityStorage.linkedClerkUserId else { return }

        AnalyticsManager.shared.identify(
            userId: clerkUserId,
            userProperties: RevenueCatCustomerInfoAnalyticsProperties.make(from: info)
        )
    }
}
