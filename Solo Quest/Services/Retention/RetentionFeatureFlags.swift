//
//  RetentionFeatureFlags.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

/// Runtime-tunable retention defaults. Remote configuration can replace these values later
/// without changing the services that enforce the product rules.
enum RetentionFeatureFlags {
    private static let protectionDurationKey = "SoloQuest.Retention.NewPlayerProtectionDurationDays"
    private static let firstCompletionPaywallEnabledKey = "SoloQuest.Retention.FirstCompletionPaywallEnabled"

    static var newPlayerProtectionDurationDays: Int {
        let configured = UserDefaults.standard.integer(forKey: protectionDurationKey)
        return configured > 0 ? configured : 7
    }

    static var isFirstCompletionPaywallEnabled: Bool {
        UserDefaults.standard.bool(forKey: firstCompletionPaywallEnabledKey)
    }
}
