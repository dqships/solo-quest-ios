//
//  NotificationManager+Delegate.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import Factory
import UserNotifications

extension NotificationManager {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let type = response.notification.request.content.userInfo["notification_type"] as? String ?? SoloQuestNotificationType.freshBoard.rawValue
        let notificationContext = response.notification.request.content.userInfo
        var properties: [String: Any] = [
            "notification_type": type,
            "source": "push_notification"
        ]
        for key in ["quest_id", "level_xp_remaining", "shortest_quest_minutes"] {
            if let value = notificationContext[key] as? String {
                properties[key] = value
            }
        }
        Container.shared.analyticsManager().track(event: "notification_opened", properties: properties)
        print("Notification tapped: \(type)")
        DispatchQueue.main.async {
            if type == SoloQuestNotificationType.nearLevelUp.rawValue {
                self.pendingDestination = .stats
            } else {
                self.pendingDestination = .quests
            }
        }
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
