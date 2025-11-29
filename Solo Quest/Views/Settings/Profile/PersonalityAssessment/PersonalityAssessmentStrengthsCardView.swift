//
//  PersonalityAssessmentStrengthsCardView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct PersonalityAssessmentStrengthsCardView: View {
    let stats: [String: Int64]

    private var topStats: ArraySlice<(key: String, value: Int64)> {
        stats.sorted(by: { $0.value > $1.value }).prefix(3)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Strengths")
                .font(.headline)
                .foregroundColor(Color.brandDarkText)
                .padding(.bottom, 4)

            ForEach(topStats, id: \.key) { stat, xp in
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.brandAccentOrange)
                        .font(.caption)

                    Text(LocalizationService.localizedStatName(stat))
                        .fontWeight(.medium)
                        .foregroundColor(Color.brandDarkText)

                    Spacer()

                    Text("\(xp) XP")
                        .font(.body)
                        .monospacedDigit()
                        .foregroundStyle(Color.brandBrownRich)
                }
                .padding(.vertical, 4)

                if stat != topStats.last?.key {
                    Divider().background(Color.brandBrownRich.opacity(0.2))
                }
            }
        }
        .padding()
        .background(Color.brandBackground)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
