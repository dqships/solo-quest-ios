//
//  QuestCategory.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum QuestCategory: String, Codable, CaseIterable, Identifiable {
    case creative
    case social
    case self_care
    case exploration
    case errand
    case reflection
    case challenge
    case finance

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .creative: return "Creative"
        case .social: return "Social"
        case .self_care: return "Self Care"
        case .exploration: return "Exploration"
        case .errand: return "Errand"
        case .reflection: return "Reflection"
        case .challenge: return "Challenge"
        case .finance: return "Finance"
        }
    }

    var icon: String {
        switch self {
        case .creative: return "paintbrush.fill"
        case .social: return "person.2.fill"
        case .self_care: return "heart.fill"
        case .exploration: return "map.fill"
        case .errand: return "bag.fill"
        case .reflection: return "brain.head.profile.fill"
        case .challenge: return "flame.fill"
        case .finance: return "dollarsign.circle.fill"
        }
    }
}
