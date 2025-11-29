//
//  AccountDataReconciliationNotification.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

extension Notification.Name {
    static let accountDataImportReconciliationDidComplete = Notification.Name(
        "accountDataImportReconciliationDidComplete"
    )
}

enum AccountDataReconciliationNotification {
    static let scopeViewIdentityKey = "accountData.scopeViewIdentity"
    static let writeOwnerIDKey = "accountData.writeOwnerID"

    static func post(scope: AccountScope) {
        NotificationCenter.default.post(
            name: .accountDataImportReconciliationDidComplete,
            object: nil,
            userInfo: [
                scopeViewIdentityKey: scope.viewIdentity,
                writeOwnerIDKey: scope.writeOwnerID
            ]
        )
    }
}
