//
//  StoreProductCatalog.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation
import SwiftUI

enum StoreProductCatalog {
    static var subscriptions: [StoreProduct] {
        [
            StoreProduct(
                title: String(localized: "Weekly Guild Pass"),
                description: String(localized: "Daily protection + unlimited rerolls"),
                price: "$2.99",
                type: .subscription,
                icon: "ProMembership",
                color: .brandAccentOrange,
                productId: "com.example.soloquest.sub.pro.weekly"
            ),
            StoreProduct(
                title: String(localized: "Monthly Guild Pass"),
                description: String(localized: "Best value for regular questers"),
                price: "$5.99",
                type: .subscription,
                icon: "ProMembership",
                color: .brandAccentOrange,
                productId: "com.example.soloquest.sub.pro.monthly"
            ),
            StoreProduct(
                title: String(localized: "Yearly Guild Pass"),
                description: String(localized: "Commit to your growth journey"),
                price: "$29.99",
                type: .subscription,
                icon: "ProMembership",
                color: .brandAccentOrange,
                productId: "com.example.soloquest.sub.pro.yearly"
            )
        ]
    }

    static var rerollPacks: [StoreProduct] {
        [
            StoreProduct(
                title: String(localized: "10 Rerolls"),
                description: String(localized: "Quick refill for extra rerolls"),
                price: "$0.99",
                type: .reroll,
                icon: "QuestPack10",
                color: .blue,
                productId: "com.example.soloquest.sidequests.10"
            ),
            StoreProduct(
                title: String(localized: "50 Rerolls"),
                description: String(localized: "More rerolls for more options"),
                price: "$2.99",
                type: .reroll,
                icon: "QuestPack50",
                color: .blue,
                productId: "com.example.soloquest.sidequests.50"
            ),
            StoreProduct(
                title: String(localized: "100 Rerolls"),
                description: String(localized: "Serious reroll pack"),
                price: "$4.99",
                type: .reroll,
                icon: "QuestPack100",
                color: .blue,
                productId: "com.example.soloquest.sidequests.100"
            )
        ]
    }
}
