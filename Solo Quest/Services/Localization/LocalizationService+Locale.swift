//
//  LocalizationService+Locale.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation

extension LocalizationService {
    /// Returns the current app locale identifier.
    static var currentLocale: String {
        return Locale.current.identifier
    }

    /// Returns the preferred language code (e.g., "en", "es", "de", "fr").
    static var preferredLanguage: String {
        return Locale.current.language.languageCode?.identifier ?? "en"
    }
}
