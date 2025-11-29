//
//  LocalizationService+Slugify.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension LocalizationService {
    /// Generates a slug-style ID from a display string.
    static func slugify(_ text: String) -> String {
        return text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
    }
}
