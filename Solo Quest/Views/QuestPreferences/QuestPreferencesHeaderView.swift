//
//  QuestPreferencesHeaderView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestPreferencesHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 36))
                .foregroundColor(.brandBrownRich)
                .padding(.bottom, 4)
            
            Text("Quest Preferences")
                .font(.title2.bold())
                .foregroundColor(.brandDarkText)
            
            Text("Tell us what kind of quests you prefer. We'll suggest more quests that match your style.")
                .font(.subheadline)
                .foregroundColor(.brandDarkText.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 8)
    }
}
