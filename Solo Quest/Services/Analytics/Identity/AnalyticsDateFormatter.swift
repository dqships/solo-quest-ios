//
//  AnalyticsDateFormatter.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import Foundation

enum AnalyticsDateFormatter {
    nonisolated static func string(from date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }
}
