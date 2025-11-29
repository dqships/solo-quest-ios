//
//  QuestCardView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Factory

struct QuestCardView: View {
    @Injected(\.questEngine) private var questEngine
    let instance: QuestInstance
    let template: QuestTemplate?
    
    // Callbacks for actions
    var onAccept: ((QuestInstance) -> Void)?
    var onComplete: ((QuestInstance) -> Void)?
    var onFail: ((QuestInstance) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text(questEngine.getLocalizedDisplayTitle(for: instance, template: template))
                    .font(.headline)
                    .foregroundColor(.brandDarkText)
                    .lineLimit(2)
                
                Text(subtitleText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.brandTextSecondary)
            }
            
            // State Content
            QuestCardStateContent(instance: instance)
            
            // Footer / Action
            QuestCardActionButton(
                instance: instance,
                onAccept: onAccept,
                onComplete: onComplete
            )
        }
        .padding()
        .background(QuestCardStyle.cardBackground(for: instance.state))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(QuestCardStyle.borderColor(for: instance.state), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Subtitles
    
    private var subtitleText: String {
        guard let template = template else { return "" }
        
        let durationConfig = questEngine.getDuration(size: template.size)
        let baseXP = Int64(instance.xpReward)
        let xpReward = Int(questEngine.awardedXP(forBaseXP: baseXP))
        let xpPenalty = Int(Double(baseXP) * 0.5)
        
        return QuestCardSubtitleFormatter.subtitleText(
            for: instance,
            durationConfig: durationConfig,
            xpReward: xpReward,
            xpPenalty: xpPenalty
        )
    }
}
