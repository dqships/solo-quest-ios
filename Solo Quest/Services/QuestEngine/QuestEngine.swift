//
//  QuestEngine.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Factory
import Foundation

@MainActor
class QuestEngine {
    @Injected(\.persistenceController) var persistence
    @Injected(\.storeKitService) var storeKit
    @Injected(\.analyticsManager) var analytics
    @Injected(\.playerLifecycleService) var lifecycle
    @Injected(\.newPlayerProtectionService) var newPlayerProtection
    @Injected(\.retentionNotificationCoordinator) var retentionNotifications
    @Injected(\.accountScopeProvider) var accountScopeProvider

    var gameData: GameData?
    var filterPreferences: QuestFilterPreferences
    var dailyPenaltyImportObserver: NSObjectProtocol?

    let goalStatMapping: [String: [String]] = [
        "Build Confidence": ["charisma", "resilience"],
        "Meet New People": ["charisma"],
        "Get Fit & Healthy": ["strength", "stamina"],
        "Stop Procrastinating": ["intelligence", "resilience"],
        "Try New Things": ["luck", "resilience"],
        "Learn & Grow": ["intelligence"]
    ]

    init() {
        self.filterPreferences = QuestFilterPreferences.load()
        loadGameData()
        observeDailyPenaltyImportReconciliation()
    }

    deinit {
        if let dailyPenaltyImportObserver {
            NotificationCenter.default.removeObserver(dailyPenaltyImportObserver)
        }
    }
}
