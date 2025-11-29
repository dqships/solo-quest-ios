//
//  RetentionNotificationCoordinator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

@MainActor
final class RetentionNotificationCoordinator {
    let notificationManager: NotificationManager
    let lifecycle: PlayerLifecycleService
    let signatureKey = "SoloQuest.Retention.NotificationSignature"
    let activeQuestKey = "SoloQuest.Retention.ActiveQuestNotificationID"

    init(notificationManager: NotificationManager, lifecycle: PlayerLifecycleService) {
        self.notificationManager = notificationManager
        self.lifecycle = lifecycle
    }
}
