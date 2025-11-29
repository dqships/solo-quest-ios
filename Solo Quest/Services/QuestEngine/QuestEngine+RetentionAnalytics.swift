//
//  QuestEngine+RetentionAnalytics.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func retentionAnalyticsProperties(context: NSManagedObjectContext) -> [String: Any] {
        return [
            "quests_completed_lifetime": completedQuestCount(context: context),
            "active_days_lifetime": lifecycle.activeDaysLifetime,
            "days_since_install": lifecycle.daysSinceInstall(),
            "rerolls_today": lifecycle.rerollsToday,
            "rerolls_lifetime": lifecycle.rerollsLifetime,
            "new_user_protection_active": newPlayerProtection.isActive()
        ]
    }
}
