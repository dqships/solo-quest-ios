//
//  LocationType.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum LocationType: String, Codable, CaseIterable, Identifiable {
    case home_indoor
    case public_indoor
    case outdoor_city
    case outdoor_nature
    case flexible

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .home_indoor: return "Home / Indoor"
        case .public_indoor: return "Public Indoor"
        case .outdoor_city: return "Outdoor City"
        case .outdoor_nature: return "Outdoor Nature"
        case .flexible: return "Anywhere"
        }
    }

    var icon: String {
        switch self {
        case .home_indoor: return "house.fill"
        case .public_indoor: return "building.2.fill"
        case .outdoor_city: return "building.columns.fill"
        case .outdoor_nature: return "leaf.fill"
        case .flexible: return "globe"
        }
    }
}
