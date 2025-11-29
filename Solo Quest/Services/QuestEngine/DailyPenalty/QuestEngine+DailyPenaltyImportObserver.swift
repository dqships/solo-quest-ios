//
//  QuestEngine+DailyPenaltyImportObserver.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

extension QuestEngine {
    func observeDailyPenaltyImportReconciliation() {
        guard dailyPenaltyImportObserver == nil else { return }

        dailyPenaltyImportObserver = NotificationCenter.default.addObserver(
            forName: .accountDataImportReconciliationDidComplete,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let scopeViewIdentity = notification.userInfo?[AccountDataReconciliationNotification.scopeViewIdentityKey]
                as? String else {
                return
            }

            Task { @MainActor [weak self] in
                self?.reconcileDailyPenaltyAfterImport(scopeViewIdentity: scopeViewIdentity)
            }
        }
    }
}
