//
//  FantasyQuestStatsPanel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct FantasyQuestStatsPanel: View {
    let xpReward: Int
    let durationString: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.brandAccentOrange)
                    .font(.caption)
                Text("+\(xpReward) XP")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .foregroundColor(.brandBrownRich)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .foregroundColor(.brandTextSecondary)
                    .font(.caption)
                Text(durationString)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.brandTextSecondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.brandCardSurface)
        .cornerRadius(8)
    }
}
