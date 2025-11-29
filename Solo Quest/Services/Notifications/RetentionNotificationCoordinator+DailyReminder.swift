//
//  RetentionNotificationCoordinator+DailyReminder.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension RetentionNotificationCoordinator {
    func refreshDailyReminder(
        shortestQuestMinutes: Int?,
        lastEngagementDate: Date?,
        levelXPRemaining: Int
    ) {
        guard notificationManager.isDailyReminderEnabled else { return }

        let type: SoloQuestNotificationType
        let title: String
        let body: String
        if let lastEngagementDate,
           Date().timeIntervalSince(lastEngagementDate) >= 2 * 24 * 60 * 60 {
            type = .returnAfterInactivity
            title = String(localized: "A fresh quest is waiting")
            body = String(localized: "No catching up. Start fresh with one quest today.")
        } else if lifecycle.activeDaysLifetime == 7 {
            type = .weeklyRecap
            title = String(localized: "Your First Chapter is ready")
            body = String(localized: "See the real progress your adventure has built.")
        } else if levelXPRemaining > 0 && levelXPRemaining <= 50 {
            type = .nearLevelUp
            title = String(localized: "Your next level is close")
            body = String.localizedStringWithFormat(
                String(localized: "You are %d XP away. One quest could do it."),
                levelXPRemaining
            )
        } else {
            type = .freshBoard
            title = String(localized: "Today's quests are ready")
            if let shortestQuestMinutes {
                body = String.localizedStringWithFormat(
                    String(localized: "Your shortest quest takes about %d minutes."),
                    shortestQuestMinutes
                )
            } else {
                body = String(localized: "Choose one useful quest and move your character forward.")
            }
        }

        let signature = "\(RetentionGameDay.identifier())|\(type.rawValue)|\(shortestQuestMinutes ?? 0)|\(levelXPRemaining)"
        guard UserDefaults.standard.string(forKey: signatureKey) != signature else { return }
        UserDefaults.standard.set(signature, forKey: signatureKey)
        notificationManager.scheduleDailyReminder(
            type: type,
            title: title,
            body: body,
            context: [
                "source": "retention_coordinator",
                "level_xp_remaining": "\(levelXPRemaining)",
                "shortest_quest_minutes": "\(shortestQuestMinutes ?? 0)"
            ]
        )
    }
}
