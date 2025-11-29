//
//  StatDetailProgressSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatDetailProgressSection: View {
    let currentXP: Int
    let nextTierXP: Int
    let progress: Double
    let motivationalText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Progress to Next Rank")
                    .font(.headline)
                    .foregroundColor(.brandDarkText)
                Spacer()
                Text("\(currentXP) / \(nextTierXP) XP")
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundColor(.brandTextSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.brandNeutral.opacity(0.2))
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.brandAccentOrange)
                        .frame(width: geometry.size.width * CGFloat(progress))
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text(motivationalText)
                .font(.caption)
                .foregroundColor(.brandTextSecondary)
                .italic()
        }
        .padding()
        .background(Color.brandCardSurface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
    }
}
