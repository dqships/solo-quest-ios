//
//  StoreKitService+SupportCode.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-24-2026
//

import Foundation
import RevenueCat

extension StoreKitService {
    var supportCode: String {
        Purchases.shared.appUserID
    }
}
