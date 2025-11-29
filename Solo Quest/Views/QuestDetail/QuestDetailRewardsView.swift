//
//  QuestDetailRewardsView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestDetailRewardsView: View {
    let xpReward: Int
    let durationString: String
    let xpLoss: Int
    let affectedStats: String
    let noviceProtectionActive: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                QuestStatPill(
                    title: "XP Reward",
                    value: "+\(xpReward)",
                    icon: "star.fill",
                    color: .brandAccentOrange
                )
                
                QuestStatPill(
                    title: "Est. Time",
                    value: durationString,
                    icon: "clock.fill",
                    color: .brandBrownDeep
                )
            }
            
            HStack(spacing: 4) {
                Image(systemName: noviceProtectionActive ? "shield.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(noviceProtectionActive ? .brandBrownRich : .red)
                Text(noviceProtectionActive ? "Novice Protection: no XP loss" : "Potential Risk: -\(xpLoss) XP")
                    .fontWeight(.bold)
                    .foregroundColor(noviceProtectionActive ? .brandBrownRich : .red)
                if !noviceProtectionActive {
                    Text("(\(affectedStats))")
                        .foregroundColor(.brandTextSecondary)
                        .lineLimit(1)
                }
            }
            .font(.caption)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }
}
