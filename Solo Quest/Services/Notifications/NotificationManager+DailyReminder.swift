//
//  NotificationManager+DailyReminder.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import Factory
import UserNotifications

extension NotificationManager {
    func scheduleDailyReminder(
        type: SoloQuestNotificationType = .freshBoard,
        title: String = String(localized: "New Quests Available!"),
        body: String = String(localized: "Your daily quests are ready. Adventure awaits!"),
        context: [String: String] = [:]
    ) {
        guard isDailyReminderEnabled else { return }

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_quest_reminder"])

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = context.merging(["notification_type": type.rawValue], uniquingKeysWith: { _, new in new })

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_quest_reminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily 9 AM notification scheduled.")
                var properties: [String: Any] = [
                    "notification_type": type.rawValue,
                    "source": "daily_reminder"
                ]
                properties.merge(context) { current, _ in current }
                Container.shared.analyticsManager().track(event: "notification_scheduled", properties: properties)
            }
        }
    }

    func cancelDailyReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_quest_reminder"])
        print("Daily reminder cancelled.")
    }
}
