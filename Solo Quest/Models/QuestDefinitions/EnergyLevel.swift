//
//  EnergyLevel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum EnergyLevel: String, Codable, CaseIterable, Identifiable {
    case low
    case medium
    case high

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .low: return "Low Energy"
        case .medium: return "Medium Energy"
        case .high: return "High Energy"
        }
    }

    var icon: String {
        switch self {
        case .low: return "battery.25percent"
        case .medium: return "battery.50percent"
        case .high: return "battery.100percent"
        }
    }
}
