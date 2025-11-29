//
//  LocalizedTopic.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

/// A topic with both an ID for localization and a fallback value.
struct LocalizedTopic: Codable, Identifiable, Hashable {
    let id: String
    let value: String

    var localizedValue: String {
        LocalizationService.localizedTopic(for: id, fallback: value)
    }
}
