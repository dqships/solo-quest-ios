//
//  PersistenceController+CloudKitEvents.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

extension PersistenceController {
    func observeCloudKitImportEvents() {
        guard let cloudContainer = container as? NSPersistentCloudKitContainer else { return }

        NotificationCenter.default.addObserver(
            forName: NSPersistentCloudKitContainer.eventChangedNotification,
            object: cloudContainer,
            queue: .main
        ) { [readiness] notification in
            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                as? NSPersistentCloudKitContainer.Event,
                event.type == .import,
                event.endDate != nil else {
                return
            }
            if event.succeeded {
                readiness.markInitialImportFinished()
            } else {
                readiness.recordImportFailure(event.error)
            }
        }
    }
}
