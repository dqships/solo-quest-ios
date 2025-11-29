//
//  QuestCardStyle.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

enum QuestCardStyle {
    static func cardBackground(for state: String?) -> Color {
        switch state {
        case "completed":
            return Color.brandBrownRich.opacity(0.05)
        case "failed":
            return Color.red.opacity(0.05)
        default:
            return Color.brandCardSurface
        }
    }
    
    static func borderColor(for state: String?) -> Color {
        switch state {
        case "active":
            return Color.brandAccentOrange
        case "completed":
            return Color.brandBrownRich.opacity(0.3)
        case "failed":
            return Color.red.opacity(0.3)
        default:
            return Color.brandPanelDark
        }
    }
}
