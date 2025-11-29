//
//  LocationService+Context.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import CoreLocation
import Foundation

extension LocationService {
    func requestLocationContext(timeoutSeconds: UInt64 = 6) async -> QuestLocationContext {
        authorizationState = LocationAuthorizationState(status: manager.authorizationStatus)

        guard CLLocationManager.locationServicesEnabled() else {
            return contextWithoutCoordinates(status: authorizationState)
        }

        if authorizationState == .notDetermined {
            return await requestAuthorizationAndLocation(timeoutSeconds: timeoutSeconds)
        }

        guard authorizationState.canUseLocation else {
            let context = contextWithoutCoordinates(status: authorizationState)
            latestContext = context
            return context
        }

        return await requestCurrentLocation(timeoutSeconds: timeoutSeconds)
    }

    func contextForGeneration(timeoutSeconds: UInt64 = 6) async -> QuestLocationContext {
        authorizationState = LocationAuthorizationState(status: manager.authorizationStatus)

        if authorizationState.canUseLocation {
            if let latestContext, latestContext.hasCoordinates {
                return latestContext
            }

            return await requestCurrentLocation(timeoutSeconds: timeoutSeconds)
        }

        return latestContext ?? contextWithoutCoordinates(status: authorizationState)
    }

    func markLocationSkipped() {
        let context = contextWithoutCoordinates(status: authorizationState)
        latestContext = context
    }

    func contextWithoutCoordinates(status: LocationAuthorizationState) -> QuestLocationContext {
        QuestLocationContext(
            authorizationStatus: status,
            capturedAt: Self.isoFormatter.string(from: Date())
        )
    }

    func context(for location: CLLocation, placemark: CLPlacemark?) -> QuestLocationContext {
        QuestLocationContext(
            authorizationStatus: authorizationState,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            horizontalAccuracyMeters: location.horizontalAccuracy,
            locality: placemark?.locality,
            administrativeArea: placemark?.administrativeArea,
            country: placemark?.country,
            capturedAt: Self.isoFormatter.string(from: Date())
        )
    }

    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
