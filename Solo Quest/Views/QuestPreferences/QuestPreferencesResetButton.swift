//
//  QuestPreferencesResetButton.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestPreferencesResetButton: View {
    let reset: () -> Void
    
    var body: some View {
        Button(action: reset) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.counterclockwise")
                Text("Reset All Preferences")
            }
            .font(.subheadline.weight(.medium))
            .foregroundColor(.red.opacity(0.8))
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.08))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}
