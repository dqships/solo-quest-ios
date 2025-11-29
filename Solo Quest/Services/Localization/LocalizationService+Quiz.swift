//
//  LocalizationService+Quiz.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension LocalizationService {
    /// Returns the localized question text for a quiz question.
    static func localizedQuizQuestion(key: String, fallback: String) -> String {
        let localized = localizedCatalogString(key, fallback: fallback, table: LocalizationTable.quiz)

        return localized
    }

    /// Returns the localized option text for a quiz answer.
    static func localizedQuizOption(key: String, fallback: String) -> String {
        let localized = localizedCatalogString(key, fallback: fallback, table: LocalizationTable.quiz)

        return localized
    }
}
