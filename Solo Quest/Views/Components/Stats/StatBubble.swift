//
//  StatBubble.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatBubble: View {
    let statName: String
    let xp: Int
    let rank: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image("RankBadge\(rank)")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            
            Text(LocalizationService.localizedStatName(statName))
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.brandTextSecondary)
                .textCase(.uppercase)
            
            Text("\(xp)")
                .font(.caption)
                .fontWeight(.black)
                .foregroundColor(.brandDarkText)
        }
        .frame(width: 85, height: 85)
        .background(Color.brandCardSurface)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.brandBrownHighlight.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
