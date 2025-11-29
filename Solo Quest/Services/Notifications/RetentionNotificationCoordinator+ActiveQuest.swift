//
//  RetentionNotificationCoordinator+ActiveQuest.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension RetentionNotificationCoordinator {
    func scheduleActiveQuestReminder(questID: String, questTitle: String, expiry: Date) {
        guard notificationManager.isDailyReminderEnabled else { return }
        guard expiry.timeIntervalSinceNow >= 45 * 60 else { return }
        guard UserDefaults.standard.string(forKey: activeQuestKey) != questID else { return }
        UserDefaults.standard.set(questID, forKey: activeQuestKey)

        let reminderDate = min(expiry.addingTimeInterval(-15 * 60), Date().addingTimeInterval(60 * 60))
        notificationManager.scheduleContextualNotification(
            type: .activeQuest,
            title: String(localized: "Your active quest is waiting"),
            body: questTitle,
            at: reminderDate,
            context: ["quest_id": questID, "source": "active_quest"]
        )
    }
}
