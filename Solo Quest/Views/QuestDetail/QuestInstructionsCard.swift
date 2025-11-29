//
//  QuestInstructionsCard.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct QuestInstructionsCard: View {
    let instructions: String
    let isAvailable: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.headline)
                .foregroundColor(.brandDarkText)

            Text(instructions)
                .font(.body)
                .foregroundColor(.brandTextSecondary)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)

            if isAvailable {
                Text("Accepting this quest will start a timer. You cannot complete the quest until the first 25% of the duration has passed.")
                    .font(.caption)
                    .foregroundColor(.brandBrownDeep)
                    .padding(.top, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandCardSurface)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
