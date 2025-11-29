//
//  FantasyQuestCard.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Factory

struct FantasyQuestCard: View {
    @Injected(\.questEngine) private var questEngine
    let instance: QuestInstance
    let template: QuestTemplate?
    
    // Callbacks for actions
    var onAccept: ((QuestInstance) -> Void)?
    var onComplete: ((QuestInstance) -> Void)?
    var onFail: ((QuestInstance) -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background Card Image
                Image("QuestCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                // Rank Badge Overlay
                VStack {
                    HStack {
                        Image("RankBadge\(questRank)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .padding(4)
                            .background(Color.brandCardSurface)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .padding(.leading, 16)
                            .padding(.top, 16)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .frame(maxHeight: 340) // Reduced height slightly to show scroll hints
            .padding(.horizontal, -10) // Negative padding to allow it to expand slightly wider within container
            
            // Quest Info Below Card
            VStack(spacing: 16) { // Reduced spacing from 16
                // Title / Description
                Text(questEngine.getLocalizedDisplayTitle(for: instance, template: template))
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(.brandDarkText)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal)
                
                // Action & Stats Row
                HStack(spacing: 12) {
                    FantasyQuestStatsPanel(
                        xpReward: xpReward,
                        durationString: durationString
                    )
                    
                    // Action Button (Takes remaining width)
                    FantasyQuestActionButton(
                        instance: instance,
                        onAccept: onAccept,
                        onComplete: onComplete
                    )
                }
                .padding(.horizontal)
                
                // Status Indicator (if active/locked)
                if instance.state != "available" {
                    FantasyQuestStatusIndicator(instance: instance)
                }
            }
            
            Spacer()
        }
        .padding(.vertical)
    }
    
    // MARK: - Helpers
    
    private var xpReward: Int {
        Int(questEngine.awardedXP(for: instance))
    }
    
    private var durationString: String {
        guard let template = template else { return "--" }
        let config = questEngine.getDuration(size: template.size)
        if config.minMinutes == config.maxMinutes {
            return "\(config.minMinutes)m"
        }
        return "\(config.minMinutes)-\(config.maxMinutes)m"
    }
    
    private var questRank: String {
        QuestRankResolver.rank(for: template, instance: instance)
    }
}
