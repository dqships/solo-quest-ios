//
//  NotificationManager+Authorization.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import Factory
import UserNotifications

extension NotificationManager {
    @objc func appWillEnterForeground() {
        checkNotificationStatus()
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let currentStatus = settings.authorizationStatus
                let previousStatus = self.lastKnownStatus

                if currentStatus != previousStatus {
                    if currentStatus == .authorized || currentStatus == .provisional {
                        if !self.isDailyReminderEnabled {
                            self.isDailyReminderEnabled = true
                        }
                    } else if currentStatus == .denied {
                        if self.isDailyReminderEnabled {
                            self.isDailyReminderEnabled = false
                        }
                    }
                    self.lastKnownStatus = currentStatus
                } else {
                    if currentStatus == .denied && self.isDailyReminderEnabled {
                        self.isDailyReminderEnabled = false
                    }
                }
            }
        }
    }

    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.checkNotificationStatus()

                if granted {
                    print("Notification permission granted.")
                    self.scheduleDailyReminder()
                } else {
                    if let error = error {
                        print("Notification permission error: \(error.localizedDescription)")
                    }
                    self.isDailyReminderEnabled = false
                }

                Container.shared.analyticsManager().track(event: "notification_permission_result", properties: [
                    "granted": granted,
                    "status": granted ? "authorized" : "denied",
                    "source": "notification_permission_prompt"
                ])

                completion?(granted)
            }
        }
    }
}
