//
//  StatDetailHeaderSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatDetailHeaderSection: View {
    let currentXP: Int
    let level: Int
    let rank: String
    let tagline: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Level \(level)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandAccentOrange)
                .padding(.bottom, -4)
            
            HStack(alignment: .center, spacing: 12) {
                Text("\(currentXP) XP")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.brandBrownDeep)
                
                Image("RankBadge\(rank)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
            }
            
            Text(tagline)
                .font(.body)
                .foregroundColor(.brandTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.brandCardSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
    }
}
