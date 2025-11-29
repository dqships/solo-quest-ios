//
//  QuestEngine+RerollFeedbackCompliance.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension QuestEngine {
    func matchesTodayRerollFeedback(quest: QuestTemplate, feedback: Set<RerollReason>) -> Bool {
        if feedback.contains(.tooMuchTime), quest.duration != .short_5_15 { return false }
        if feedback.contains(.tooMuchEnergy), quest.energyLevel != .low { return false }
        if feedback.contains(.tooSocial), quest.socialIntensity != .solo { return false }
        if feedback.contains(.cannotDoItHere), quest.locationType != .home_indoor && quest.locationType != .flexible { return false }
        if feedback.contains(.costsMoney), quest.costLevel != .free { return false }
        return true
    }
}
