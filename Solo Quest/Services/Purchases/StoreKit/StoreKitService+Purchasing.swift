//
//  StoreKitService+Purchasing.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 08-25-2026
//

import Foundation
import RevenueCat

extension StoreKitService {
    func purchase(package: Package) async throws -> PurchaseResult {
        let token = captureExternalCustomerInfoToken()
        let result = try await Purchases.shared.purchase(package: package)
        if let token {
            _ = applyCustomerInfo(result.customerInfo, token: token)
        }
        return PurchaseResult(
            customerInfo: result.customerInfo,
            userCancelled: result.userCancelled,
            transaction: result.transaction
        )
    }

    func restorePurchases() async throws -> CustomerInfo {
        let token = captureExternalCustomerInfoToken()
        let info = try await Purchases.shared.restorePurchases()
        if let token {
            _ = applyCustomerInfo(info, token: token)
        }
        return info
    }
}
