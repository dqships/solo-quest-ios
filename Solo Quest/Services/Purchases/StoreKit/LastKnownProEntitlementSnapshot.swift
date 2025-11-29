//
//  LastKnownProEntitlementSnapshot.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

struct LastKnownProEntitlementSnapshot: Codable {
    let clerkUserId: String
    let expirationDate: Date
    let anonymousRevenueCatAppUserID: String?

    init(
        clerkUserId: String,
        expirationDate: Date,
        anonymousRevenueCatAppUserID: String? = nil
    ) {
        self.clerkUserId = clerkUserId
        self.expirationDate = expirationDate
        self.anonymousRevenueCatAppUserID = anonymousRevenueCatAppUserID
    }

    func isActive(at date: Date = Date()) -> Bool {
        expirationDate > date
    }
}
