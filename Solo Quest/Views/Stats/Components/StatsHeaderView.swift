//
//  StatsHeaderView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatsHeaderView: View {
    let user: UserProfile
    let levelProgress: Double
    let currentLevelXP: Int
    let nextLevelXP: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Your Stats")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.brandDarkText)
                    Text("Every quest you attempt leaves a mark here.")
                        .font(.subheadline)
                        .foregroundColor(.brandTextSecondary)
                }
                Spacer()
            }

            HStack(spacing: 16) {
                Image("RankBadge\(user.rank)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Level \(user.level)")
                            .font(.headline)
                            .foregroundColor(.brandDarkText)
                        Spacer()
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.brandNeutral.opacity(0.3))
                                .cornerRadius(4)

                            Rectangle()
                                .fill(Color.brandAccentOrange)
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
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
        }
        .padding(.horizontal)
    }
}
