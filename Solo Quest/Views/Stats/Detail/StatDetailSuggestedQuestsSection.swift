//
//  StatDetailSuggestedQuestsSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatDetailSuggestedQuestsSection: View {
    let statName: String
    let suggestedQuests: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suggested Quests")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Want to boost \(LocalizationService.localizedStatName(statName)) faster? Try these:")
                    .font(.subheadline)
                    .foregroundColor(.brandTextSecondary)
                
                ForEach(suggestedQuests, id: \.self) { quest in
                    HStack(spacing: 12) {
                        Image(systemName: "scroll")
                            .foregroundColor(.brandBrownRich)
                        Text(quest)
                            .font(.body)
                            .foregroundColor(.brandDarkText)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.brandCardSurface)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
        }
    }
}
