//
//  StatTileView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct StatTileView: View {
    let statName: String
    let xp: Int
    let level: Int
    let rank: String
    let progress: Double
    let tagline: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text(LocalizationService.localizedStatName(statName))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.brandDarkText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
            HStack(spacing: 6) {
                Text("Lvl \(level)")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandTextSecondary)

                Image("RankBadge\(rank)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
        
        // Value
        Text("\(xp) XP")
            .font(.headline)
            .fontWeight(.heavy)
            .foregroundColor(.brandBrownDeep)
        
        // Progress Bar
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.brandNeutral.opacity(0.2))
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(Color.brandAccentOrange)
                    .frame(width: geometry.size.width * CGFloat(progress))
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
        
        // Tagline
        Text(tagline)
            .font(.caption2)
            .foregroundColor(.brandTextSecondary)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true) // Allow wrapping
    }
    .padding(12)
    .background(Color.brandCardSurface)
    .cornerRadius(12)
    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

