//
//  SoloQuestAppBootstrap.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Factory
import Foundation
import UserNotifications

enum SoloQuestAppBootstrap {
    static func configureStartupServices() {
        configureRevenueCat()
        forceQuestEngineLoad()
        configureNotificationDelegate()
    }

    private static func configureRevenueCat() {
        RevenueCatConfigurator.configureIfNeeded()
    }


    private static func forceQuestEngineLoad() {
        let _ = Container.shared.questEngine()
    }

    private static func configureNotificationDelegate() {
        let notificationManager = Container.shared.notificationManager()
        UNUserNotificationCenter.current().delegate = notificationManager
    }
}
