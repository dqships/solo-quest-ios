//
//  QuestFilterTagsView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestFilterTagsView: View {
    let template: QuestTemplate
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let cat = template.category {
                    QuestFilterTag(icon: cat.icon, text: cat.displayName)
                }
                if let si = template.socialIntensity {
                    QuestFilterTag(icon: si.icon, text: si.displayName)
                }
                if let el = template.energyLevel {
                    QuestFilterTag(icon: el.icon, text: el.displayName)
                }
                if let loc = template.locationType {
                    QuestFilterTag(icon: loc.icon, text: loc.displayName)
                }
                if let cl = template.costLevel {
                    QuestFilterTag(icon: cl.icon, text: cl.displayName)
                }
                if let cz = template.comfortZone {
                    QuestFilterTag(icon: cz.icon, text: cz.displayName)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct QuestFilterTag: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(.system(size: 11, weight: .medium))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.brandBrownRich.opacity(0.08))
        .foregroundColor(.brandBrownRich)
        .cornerRadius(8)
    }
}
