//
//  QuestStatusBadge.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestStatusBadge: View {
    let state: String?
    
    var body: some View {
        Text(key)
            .textCase(.uppercase)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(8)
    }
    
    private var key: LocalizedStringKey {
        switch state {
        case "available": return "Available"
        case "locked": return "In Progress (Locked)"
        case "active": return "In Progress (Active)"
        case "completed": return "Completed"
        case "failed": return "Failed"
        default: return "Unknown"
        }
    }
    
    private var color: Color {
        switch state {
        case "available": return .brandTextSecondary
        case "locked": return .brandBrownRich
        case "active": return .brandAccentOrange
        case "completed": return .brandBrownRich
        case "failed": return .red
        default: return .gray
        }
    }
}
