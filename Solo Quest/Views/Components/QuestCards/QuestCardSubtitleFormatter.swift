//
//  QuestCardSubtitleFormatter.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum QuestCardSubtitleFormatter {
    static func subtitleText(
        for instance: QuestInstance,
        durationConfig: QuestDuration,
        xpReward: Int,
        xpPenalty: Int
    ) -> String {
        let duration: String
        if durationConfig.minMinutes == durationConfig.maxMinutes {
            duration = "\(durationConfig.minMinutes) min"
        } else {
            duration = "\(durationConfig.minMinutes)–\(durationConfig.maxMinutes) min"
        }
        
        if instance.state == "completed" {
            return "Completed • +\(xpReward) XP earned"
        } else if instance.state == "failed" {
            return "Failed • −\(xpPenalty) XP penalty"
        }
        
        return "Est. \(duration) • +\(xpReward) XP"
    }
}
