//
//  DurationBucket.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum DurationBucket: String, Codable, CaseIterable, Identifiable {
    case short_5_15
    case medium_15_30
    case long_30_60
    case marathon_60_plus

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .short_5_15: return "5–15 min"
        case .medium_15_30: return "15–30 min"
        case .long_30_60: return "30–60 min"
        case .marathon_60_plus: return "60+ min"
        }
    }

    var icon: String {
        switch self {
        case .short_5_15: return "clock.fill"
        case .medium_15_30: return "clock.fill"
        case .long_30_60: return "clock.badge.fill"
        case .marathon_60_plus: return "clock.badge.fill"
        }
    }
}
