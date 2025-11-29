//
//  PurchaseResult.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import RevenueCat

struct PurchaseResult {
    let customerInfo: CustomerInfo
    let userCancelled: Bool
    let transaction: StoreTransaction?
}
