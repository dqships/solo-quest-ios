//
//  PenaltyCustomerInfoPayload.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation
import RevenueCat

struct PenaltyCustomerInfoPayload {
    let customerInfo: CustomerInfo?
    let isPro: Bool
    let proExpirationDate: Date?
}
