//
//  LocationService+Settings.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import Foundation
import UIKit

extension LocationService {
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        UIApplication.shared.open(url)
    }

    func markPersonalizationPromptSeen() {
        LocationPersonalizationPromptStore.hasSeenPrompt = true
    }

}
