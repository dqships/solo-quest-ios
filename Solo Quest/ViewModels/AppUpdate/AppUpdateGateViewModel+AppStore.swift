//
//  AppUpdateGateViewModel+AppStore.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import UIKit

extension AppUpdateGateViewModel {
    func openAppStoreForRequiredUpdate() {
        guard let appStoreURL = requiredUpdate?.appStoreURL else { return }

        UIApplication.shared.open(appStoreURL)
    }
}
