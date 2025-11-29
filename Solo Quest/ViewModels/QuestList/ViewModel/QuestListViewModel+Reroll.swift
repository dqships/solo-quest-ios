//
//  QuestListViewModel+Reroll.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Clerk
import Foundation

extension QuestListViewModel {
    func requestReroll() {
        analytics.track(event: "quest_reroll_requested", properties: [
            "source": "quest_list",
            "rerolls_today": lifecycle.rerollsToday,
            "rerolls_lifetime": lifecycle.rerollsLifetime,
            "new_user_protection_active": questEngine.newPlayerProtection.isActive(),
            "is_pro": storeKit.isPro,
            "user_level": user?.level ?? 1,
            "user_rank": user?.rank ?? "E",
            "user_total_xp": user?.totalXp ?? 0,
            "user_current_streak": user?.streakDays ?? 0,
            "active_days_lifetime": lifecycle.activeDaysLifetime,
            "days_since_install": lifecycle.daysSinceInstall()
        ])
    }

    func rerollQuests(reason: RerollReason) {
        analytics.track(event: "quest_reroll_reason_selected", properties: [
            "source": "quest_list",
            "reroll_reason": reason.rawValue,
            "rerolls_today": lifecycle.rerollsToday,
            "rerolls_lifetime": lifecycle.rerollsLifetime,
            "new_user_protection_active": questEngine.newPlayerProtection.isActive(),
            "is_pro": storeKit.isPro
        ])
        do {
            try questEngine.rerollDailyQuests(reason: reason)
        } catch QuestEngine.QuestError.insufficientCredits {
            showToast = true
            toastMessage = String(localized: "You are out of rerolls.")
            toastActionTitle = String(localized: "Get More")
            toastAction = { [weak self] in
                if ClerkConfiguration.requiresSignIn(user: Clerk.shared.user) {
                    self?.openAuthSheet = true
                } else {
                    self?.storeSource = .rerollLimit
                    self?.openStoreSheet = true
                }
            }
        } catch QuestEngine.QuestError.questInProgress {
            showToast = true
            toastMessage = String(localized: "Cannot reroll while a quest is active.")
            toastActionTitle = nil
            toastAction = nil
        } catch QuestEngine.QuestError.noSuitableQuests {
            showToast = true
            toastMessage = String(localized: "No new quests fit today's choices. Try adjusting your preferences.")
            toastActionTitle = nil
            toastAction = nil
        } catch {
            print("❌ Reroll failed: \(error)")
        }
    }

    var canReroll: Bool {
        guard Clerk.shared.user != nil else { return false }

        let credits = user?.sideQuestCredits ?? 0
        let hasCredits = storeKit.isPro || questEngine.newPlayerProtection.isActive() || credits > 0
        let hasActiveOrLocked = dailyQuests.contains { $0.state == "active" || $0.state == "locked" }

        return hasCredits && !hasActiveOrLocked
    }
}
