//
//  RevenueCatConfigurator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//  Modified by DaQuan Louden on 11-03-2026
//

import Foundation
import RevenueCat

enum RevenueCatConfigurator {
    /// Used when no key is configured, so the SDK starts and purchases fail instead of the app crashing.
    private static let placeholderAPIKey = "appl_REPLACE_WITH_YOUR_KEY"

    static var hasAPIKey: Bool {
        ConfiguredInfoValue.string(forKey: "RevenueCatAPIKey") != nil
    }

    static func configureIfNeeded() {
        guard !AppStoreScreenshotMode.isEnabled, !AppRuntimeMode.isRunningXCTest else { return }
        guard !Purchases.isConfigured else { return }

        let revenueCatKey = ConfiguredInfoValue.string(forKey: "RevenueCatAPIKey") ?? placeholderAPIKey

        #if DEBUG
        Purchases.logLevel = .debug
        #else
        Purchases.logLevel = .error
        #endif

        Purchases.configure(withAPIKey: revenueCatKey)
    }
}
