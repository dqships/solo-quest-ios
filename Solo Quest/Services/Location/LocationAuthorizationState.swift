//
//  LocationAuthorizationState.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import CoreLocation
import Foundation

enum LocationAuthorizationState: String, Codable {
    case notDetermined
    case restricted
    case denied
    case authorizedWhenInUse
    case authorizedAlways
    case unknown

    init(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self = .notDetermined
        case .restricted:
            self = .restricted
        case .denied:
            self = .denied
        case .authorizedWhenInUse:
            self = .authorizedWhenInUse
        case .authorizedAlways:
            self = .authorizedAlways
        @unknown default:
            self = .unknown
        }
    }

    var canUseLocation: Bool {
        self == .authorizedWhenInUse || self == .authorizedAlways
    }
}
