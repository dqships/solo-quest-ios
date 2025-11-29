//
//  LocationAuthorizationState+Display.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import Foundation

extension LocationAuthorizationState {
    var displayTitle: String {
        switch self {
        case .notDetermined:
            return String(localized: "Not Asked")
        case .authorizedWhenInUse, .authorizedAlways:
            return String(localized: "Enabled")
        case .denied:
            return String(localized: "Denied")
        case .restricted:
            return String(localized: "Restricted")
        case .unknown:
            return String(localized: "Unknown")
        }
    }

    var settingsActionTitle: String {
        switch self {
        case .notDetermined:
            return String(localized: "Enable")
        case .authorizedWhenInUse, .authorizedAlways:
            return String(localized: "Enabled")
        case .denied, .restricted:
            return String(localized: "Open Settings")
        case .unknown:
            return String(localized: "Check")
        }
    }
}
