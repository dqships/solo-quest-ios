//
//  QuestPreferencesInfoView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestPreferencesInfoView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.brandBrownRich.opacity(0.6))
            Text("Preferences influence which quests appear more often. You'll still see a variety of quests to keep things fresh.")
                .font(.caption)
                .foregroundColor(.brandDarkText.opacity(0.5))
        }
        .padding()
        .background(Color.brandBackground.opacity(0.5))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
