//
//  LocationService+Delegate.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import CoreLocation
import Foundation

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationState = LocationAuthorizationState(status: manager.authorizationStatus)

            if authorizationState.canUseLocation {
                manager.requestLocation()
            } else if authorizationState != .notDetermined {
                resume(with: contextWithoutCoordinates(status: authorizationState))
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        Task { @MainActor in
            resume(with: context(for: location, placemark: nil))
            let placemark = try? await geocoder.reverseGeocodeLocation(location).first

            if let placemark {
                latestContext = context(for: location, placemark: placemark)
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            resume(with: contextWithoutCoordinates(status: authorizationState))
        }
    }
}
