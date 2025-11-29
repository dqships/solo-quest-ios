//
//  StatDetailView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatDetailView: View {
    let statName: String
    let currentXP: Int
    let tagline: String
    @ObservedObject var viewModel: StatsViewModel
    
    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    StatDetailHeaderSection(
                        currentXP: currentXP,
                        level: viewModel.getAttributeLevel(xp: currentXP),
                        rank: viewModel.getRank(from: currentXP),
                        tagline: tagline
                    )
                    
                    StatDetailProgressSection(
                        currentXP: currentXP,
                        nextTierXP: viewModel.getNextTierXP(currentXP: currentXP),
                        progress: viewModel.getProgress(currentXP: currentXP),
                        motivationalText: StatMotivationText.text(for: statName)
                    )
                    
                    StatDetailRecentActivitySection(
                        statName: statName,
                        activities: viewModel.getActivities(for: statName)
                    )
                    
                    StatDetailSuggestedQuestsSection(
                        statName: statName,
                        suggestedQuests: viewModel.getSuggestedQuests(for: statName)
                    )
                    
                    Spacer(minLength: 40)
                }
                .padding()
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(LocalizationService.localizedStatName(statName))
                    .font(.headline)
                    .foregroundColor(.brandDarkText)
            }
        }
    }
}
