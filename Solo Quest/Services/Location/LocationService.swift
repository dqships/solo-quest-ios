//
//  LocationService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import Combine
import CoreLocation
import Foundation

@MainActor
final class LocationService: NSObject, ObservableObject {
    @Published var authorizationState: LocationAuthorizationState
    @Published var latestContext: QuestLocationContext?

    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var continuation: CheckedContinuation<QuestLocationContext, Never>?
    var timeoutTask: Task<Void, Never>?

    override init() {
        authorizationState = LocationAuthorizationState(status: manager.authorizationStatus)
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    deinit {
        timeoutTask?.cancel()
    }
}
