//
//  StorePaywallType.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Foundation

enum StorePaywallType: String, Identifiable {
    case guildPass
    case rerolls

    var id: String { rawValue }

    var offeringIdentifier: String {
        switch self {
        case .guildPass:
            return RevenueCatOfferingID.subscription
        case .rerolls:
            return RevenueCatOfferingID.rerolls
        }
    }

    var analyticsSource: String {
        switch self {
        case .guildPass:
            return "store_guild_pass_paywall"
        case .rerolls:
            return "store_rerolls_paywall"
        }
    }

    var analyticsName: String {
        switch self {
        case .guildPass:
            return String(localized: "Guild Pass")
        case .rerolls:
            return String(localized: "Rerolls")
        }
    }

    var analyticsProductType: String {
        switch self {
        case .guildPass:
            return "subscription"
        case .rerolls:
            return "reroll"
        }
    }

    var alertTitle: String {
        switch self {
        case .guildPass:
            return String(localized: "Guild Pass")
        case .rerolls:
            return String(localized: "Rerolls")
        }
    }
}
