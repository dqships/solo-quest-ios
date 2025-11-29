//
//  LivePenaltyCustomerInfoFetcher.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation
import RevenueCat

@MainActor
final class LivePenaltyCustomerInfoFetcher: PenaltyCustomerInfoFetching {
    func fetchCustomerInfo() async throws -> PenaltyCustomerInfoPayload {
        let customerInfo = try await Purchases.shared.customerInfo()
        let entitlement = customerInfo.entitlements["pro"]
        return PenaltyCustomerInfoPayload(
            customerInfo: customerInfo,
            isPro: entitlement?.isActive == true,
            proExpirationDate: entitlement?.expirationDate
        )
    }
}
