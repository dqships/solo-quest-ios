//
//  LocalizedCharacter.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

/// A character reference with both an ID for localization and a fallback value.
struct LocalizedCharacter: Codable, Identifiable, Hashable {
    let id: String
    let value: String

    var localizedValue: String {
        LocalizationService.localizedCharacter(for: id, fallback: value)
    }
}
