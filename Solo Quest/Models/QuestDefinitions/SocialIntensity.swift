//
//  SocialIntensity.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum SocialIntensity: String, Codable, CaseIterable, Identifiable {
    case solo
    case one_on_one
    case small_group
    case strangers_optional
    case strangers_required

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .solo: return "Solo"
        case .one_on_one: return "One-on-One"
        case .small_group: return "Small Group"
        case .strangers_optional: return "Strangers Optional"
        case .strangers_required: return "Strangers Required"
        }
    }

    var icon: String {
        switch self {
        case .solo: return "person.fill"
        case .one_on_one: return "person.2.fill"
        case .small_group: return "person.3.fill"
        case .strangers_optional: return "person.fill.questionmark"
        case .strangers_required: return "person.fill.badge.plus"
        }
    }
}
