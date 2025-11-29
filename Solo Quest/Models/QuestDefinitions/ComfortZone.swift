//
//  ComfortZone.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum ComfortZone: String, Codable, CaseIterable, Identifiable {
    case easy
    case stretch
    case bold

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .easy: return "Comfortable"
        case .stretch: return "Stretch"
        case .bold: return "Bold"
        }
    }

    var icon: String {
        switch self {
        case .easy: return "sofa.fill"
        case .stretch: return "figure.walk"
        case .bold: return "bolt.fill"
        }
    }
}
