//
//  NotificationManager.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import UserNotifications
import Combine
import UIKit

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    @Published var pendingDestination: MainTab?
    @Published var isDailyReminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isDailyReminderEnabled, forKey: "isDailyReminderEnabled")
            if isDailyReminderEnabled {
                requestAuthorization()
            } else {
                cancelDailyReminder()
            }
        }
    }

    var lastKnownStatus: UNAuthorizationStatus {
        get {
            let raw = UserDefaults.standard.integer(forKey: "lastKnownNotificationStatus")
            return UNAuthorizationStatus(rawValue: raw) ?? .notDetermined
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "lastKnownNotificationStatus")
        }
    }

    override private init() {
        self.isDailyReminderEnabled = UserDefaults.standard.bool(forKey: "isDailyReminderEnabled")
        super.init()

        checkNotificationStatus()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
}
