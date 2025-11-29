//
//  LocalizationService+Goals.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension LocalizationService {
    /// Returns the localized display name for a goal.
    static func localizedGoalName(_ goalKey: String) -> String {
        let key = "goal.\(slugify(goalKey))"
        let localized = localizedCatalogString(key, fallback: goalKey, table: LocalizationTable.goals)

        return localized
    }
}
