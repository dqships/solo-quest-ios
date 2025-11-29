//
//  LocalizationService+Catalog.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension LocalizationService {
    static func localizedCatalogString(_ key: String, fallback: String? = nil, table: String? = nil) -> String {
        let localized = Bundle.main.localizedString(forKey: key, value: nil, table: table)

        if localized == key {
            return fallback ?? key
        }

        return localized
    }

    /// Returns the localized template string for a given quest ID.
    static func localizedQuestTemplate(for questId: String, fallback: String) -> String {
        let key = "quest.\(questId)"
        let localized = localizedCatalogString(key, fallback: fallback, table: LocalizationTable.questContent)

        return localized
    }

    /// Returns the localized string for a given topic ID.
    static func localizedTopic(for topicId: String, fallback: String) -> String {
        let key = "topic.\(topicId)"
        let localized = localizedCatalogString(key, fallback: fallback, table: LocalizationTable.questContent)

        return localized
    }

    /// Returns the localized string for a given character ID.
    static func localizedCharacter(for characterId: String, fallback: String) -> String {
        let key = "character.\(characterId)"
        let localized = localizedCatalogString(key, fallback: fallback, table: LocalizationTable.questContent)

        return localized
    }
}
