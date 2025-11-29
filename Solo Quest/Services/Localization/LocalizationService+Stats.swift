//
//  LocalizationService+Stats.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension LocalizationService {
    /// Returns the localized display name for a stat.
    static func localizedStatName(_ statKey: String) -> String {
        let normalizedKey = statKey.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let key = "stat.\(normalizedKey)"
        let localized = localizedCatalogString(key, fallback: statKey.capitalized, table: LocalizationTable.stats)

        return localized
    }

    /// Returns the localized tagline for a stat.
    static func localizedStatTagline(_ statKey: String) -> String {
        let normalizedKey = statKey.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let key = "stat.tagline.\(normalizedKey)"
        let localized = localizedCatalogString(
            key,
            fallback: getDefaultTagline(for: normalizedKey),
            table: LocalizationTable.stats
        )

        return localized
    }

    private static func getDefaultTagline(for statKey: String) -> String {
        switch statKey {
        case "luck": return "Serendipity, risk, and putting yourself in new situations."
        case "charisma": return "Conversations, connection, presence, and social courage."
        case "strength": return "Physical power, effort, and moving your body on purpose."
        case "stamina": return "Endurance, sticking with things, and longer sessions."
        case "resilience": return "Emotional toughness, facing discomfort, and trying again."
        case "intelligence": return "Learning, reflecting, and thinking more clearly."
        default: return ""
        }
    }
}
