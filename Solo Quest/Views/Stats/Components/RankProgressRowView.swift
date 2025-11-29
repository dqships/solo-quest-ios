//
//  RankProgressRowView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct RankProgressRowView: View {
    let rank: RankConfig
    let isActive: Bool
    let isPast: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image("RankBadge\(rank.id)")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .saturation(isActive || isPast ? 1.0 : 0.0)
                .opacity(isActive || isPast ? 1.0 : 0.4)
                .shadow(color: .black.opacity(isActive ? 0.2 : 0.0), radius: 2, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Rank \(rank.id)")
                    .font(.headline)
                    .fontWeight(isActive ? .bold : .medium)
                    .foregroundColor(isActive ? .brandDarkText : (isPast ? .brandTextSecondary : .brandNeutral))
                
                Text("Levels \(rank.minLevel) – \(rank.maxLevel)")
                    .font(.caption)
                    .foregroundColor(.brandTextSecondary)
            }
            
            Spacer()
            
            if isActive {
                Text("Current")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.brandAccentOrange.opacity(0.2))
                    .foregroundColor(.brandAccentOrange)
                    .cornerRadius(8)
            } else if isPast {
                Image(systemName: "checkmark")
                    .foregroundColor(.brandBrownRich)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.brandNeutral.opacity(0.5))
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.brandCardSurface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isActive ? Color.brandAccentOrange : Color.clear, lineWidth: 1)
        )
    }
}
