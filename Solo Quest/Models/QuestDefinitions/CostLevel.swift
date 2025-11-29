//
//  CostLevel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum CostLevel: String, Codable, CaseIterable, Identifiable {
    case free
    case cheap
    case moderate
    case expensive

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .cheap: return "Under $10"
        case .moderate: return "Moderate"
        case .expensive: return "Expensive"
        }
    }

    var icon: String {
        switch self {
        case .free: return "gift.fill"
        case .cheap: return "dollarsign"
        case .moderate: return "dollarsign"
        case .expensive: return "dollarsign"
        }
    }
}
