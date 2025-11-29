//
//  HeaderView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct HeaderView: View {
    let user: UserProfile
    var levelProgress: Double = 0.0
    var currentLevelXP: Int = 0
    var nextLevelXP: Int = 100
    
    var body: some View {
        VStack(spacing: 12) {
            // Top Row: Rank & Level
            HStack {
                // Rank Badge
                ZStack {
                    Circle()
                        .fill(Color.brandBrownRich)
                        .frame(width: 44, height: 44)
                    Text(user.rank)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.brandSkin)
                }
                
                VStack(alignment: .leading) {
                    Text("Level \(user.level)")
                        .font(.headline)
                        .foregroundColor(.brandDarkText)
                    Text("Player")
                        .font(.caption)
                        .foregroundColor(.brandTextSecondary)
                }
                
                Spacer()
                
                // Streak
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.brandAccentOrange)
                    Text("\(user.streakDays) Day Streak")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.brandBrownDeep)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.brandAccentOrange.opacity(0.15))
                .cornerRadius(12)
            }
            
            // XP Bar
            VStack(alignment: .leading, spacing: 4) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.brandNeutral.opacity(0.3))
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.brandAccentOrange, .brandBrownHighlight]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: geometry.size.width * CGFloat(levelProgress))
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
                
                Text("\(currentLevelXP) / \(nextLevelXP) XP to Level \(user.level + 1)")
                    .font(.caption2)
                    .foregroundColor(.brandTextSecondary)
            }
        }
        .padding()
        .background(Color.brandCardSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
