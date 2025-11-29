//
//  ConfiguredInfoValue.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11-03-2026
//

import Foundation

/// Reads a service value that the build settings place in Info.plist.
/// Returns nil when the value is missing, empty, or left as an unexpanded build setting.
enum ConfiguredInfoValue {
    static func string(forKey key: String, in bundle: Bundle = .main) -> String? {
        guard let rawValue = bundle.object(forInfoDictionaryKey: key) as? String else { return nil }

        let value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty, !value.hasPrefix("$(") else { return nil }
        return value
    }
}
