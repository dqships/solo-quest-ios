//
//  LocalizationService+Legal.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension LocalizationService {
    /// Returns the localized Privacy Policy.
    static func localizedPrivacyPolicy(fallback: String) -> String {
        let key = "legal.privacy_policy"
        let localized = localizedCatalogString(key, fallback: fallback, table: LocalizationTable.legal)

        return localized
    }

    /// Returns the localized Terms of Service.
    static func localizedTermsOfService(fallback: String) -> String {
        let key = "legal.terms_of_service"
        let localized = localizedCatalogString(key, fallback: fallback, table: LocalizationTable.legal)

        return localized
    }
}
