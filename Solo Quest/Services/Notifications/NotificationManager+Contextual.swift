//
//  NotificationManager+Contextual.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Factory
import Foundation
import UserNotifications

extension NotificationManager {
    /// Replaces a prior contextual reminder. The daily board reminder remains the low-volume baseline.
    func scheduleContextualNotification(
        type: SoloQuestNotificationType,
        title: String,
        body: String,
        at date: Date,
        context: [String: String] = [:]
    ) {
        guard isDailyReminderEnabled else { return }
        let center = UNUserNotificationCenter.current()
        let identifiers = SoloQuestNotificationType.allRequestIdentifiers
        center.removePendingNotificationRequests(withIdentifiers: identifiers)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = context.merging(["notification_type": type.rawValue], uniquingKeysWith: { _, new in new })

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        center.add(UNNotificationRequest(identifier: type.requestIdentifier, content: content, trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false))) { error in
            guard error == nil else { return }
            var properties: [String: Any] = [
                "notification_type": type.rawValue,
                "source": "notification_manager"
            ]
            properties.merge(context) { current, _ in current }
            Container.shared.analyticsManager().track(event: "notification_scheduled", properties: properties)
        }
    }
}
