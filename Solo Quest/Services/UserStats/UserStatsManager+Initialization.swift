//
//  UserStatsManager+Initialization.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Factory
import Foundation

extension UserStatsManager {
    func initializeStats(with stats: [String: Int64]) {
        let context = persistence.container.viewContext
        let userStats = fetchOrCreateUserStats(context: context)
        let appliedKey = "SoloQuest.Onboarding.PersonalityBaselineApplied"
        guard !UserDefaults.standard.bool(forKey: appliedKey) else { return }
        let lifecycleStarted = Container.shared.playerLifecycleService().usableStartedAt != nil
        guard userStats.totalXP == 0 || lifecycleStarted else { return }

        userStats.luckXP += stats["luck"] ?? 0
        userStats.charismaXP += stats["charisma"] ?? 0
        userStats.strengthXP += stats["strength"] ?? 0
        userStats.staminaXP += stats["stamina"] ?? 0
        userStats.resilienceXP += stats["resilience"] ?? 0
        userStats.intelligenceXP += stats["intelligence"] ?? 0

        userStats.totalXP += stats.values.reduce(0, +)

        let progress = InitialUserProgress.calculate(totalXP: userStats.totalXP)
        userStats.rank = progress.rank
        userStats.level = progress.level

        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: appliedKey)
        } catch {
            context.refresh(userStats, mergeChanges: false)
            print("❌ UserStatsManager: Failed to save initial stats: \(error)")
        }
    }
}
