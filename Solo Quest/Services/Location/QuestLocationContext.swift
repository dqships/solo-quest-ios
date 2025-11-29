//
//  QuestLocationContext.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import Foundation

struct QuestLocationContext: Codable, Equatable {
    let authorizationStatus: String
    let latitude: Double?
    let longitude: Double?
    let horizontalAccuracyMeters: Double?
    let locality: String?
    let administrativeArea: String?
    let country: String?
    let capturedAt: String?

    init(
        authorizationStatus: LocationAuthorizationState,
        latitude: Double? = nil,
        longitude: Double? = nil,
        horizontalAccuracyMeters: Double? = nil,
        locality: String? = nil,
        administrativeArea: String? = nil,
        country: String? = nil,
        capturedAt: String? = nil
    ) {
        self.authorizationStatus = authorizationStatus.rawValue
        self.latitude = latitude
        self.longitude = longitude
        self.horizontalAccuracyMeters = horizontalAccuracyMeters
        self.locality = locality
        self.administrativeArea = administrativeArea
        self.country = country
        self.capturedAt = capturedAt
    }

    var hasCoordinates: Bool {
        latitude != nil && longitude != nil
    }
}
