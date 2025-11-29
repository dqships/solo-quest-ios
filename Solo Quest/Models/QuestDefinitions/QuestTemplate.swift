//
//  QuestTemplate.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct QuestTemplate: Codable, Identifiable, Hashable {
    let id: String
    let template: String
    let slots: [String]
    let size: String
    let level: Int?
    let primaryStat: String
    let secondaryStats: [String]

    let category: QuestCategory?
    let socialIntensity: SocialIntensity?
    let energyLevel: EnergyLevel?
    let duration: DurationBucket?
    let locationType: LocationType?
    let costLevel: CostLevel?
    let timeOfDay: TimeOfDay?
    let comfortZone: ComfortZone?

    /// Returns the localized template, falling back to the original English template if not available.
    var localizedTemplate: String {
        LocalizationService.localizedQuestTemplate(for: id, fallback: template)
    }

    /// Helper to get readable text with slots shown as placeholders.
    var title: String {
        return localizedTemplate.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    }
}
