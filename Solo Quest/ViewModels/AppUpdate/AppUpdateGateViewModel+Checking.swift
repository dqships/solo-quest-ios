//
//  AppUpdateGateViewModel+Checking.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Foundation

extension AppUpdateGateViewModel {
    func checkForUpdate() async {
        guard !isCheckingForUpdate else { return }

        isCheckingForUpdate = true
        defer {
            isCheckingForUpdate = false
            hasCompletedInitialCheck = true
        }

        do {
            requiredUpdate = try await appUpdateService.availableUpdate()
        } catch { }
    }
}
