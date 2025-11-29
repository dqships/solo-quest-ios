//
//  PersonalityAssessmentRankCardView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct PersonalityAssessmentRankCardView: View {
    let rank: String
    let level: Int16

    var body: some View {
        VStack(spacing: 16) {
            Image("RankBadge\(rank)")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)

            VStack(spacing: 4) {
                Text("Current Rank: \(rank)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.brandDarkText)

                Text("Level \(level)")
                    .font(.headline)
                    .foregroundColor(Color.brandTextSecondary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.brandBackground)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }
}
