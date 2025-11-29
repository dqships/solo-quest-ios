//
//  RetentionGameDay.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

enum RetentionGameDay {
    static func identifier(for date: Date = Date()) -> String {
        let adjusted = Calendar.current.date(byAdding: .hour, value: -4, to: date) ?? date
        let components = Calendar.current.dateComponents([.year, .month, .day], from: adjusted)
        return String(format: "%04d-%02d-%02d", components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }

    static func start(for date: Date) -> Date {
        let adjusted = Calendar.current.date(byAdding: .hour, value: -4, to: date) ?? date
        let start = Calendar.current.startOfDay(for: adjusted)
        return Calendar.current.date(byAdding: .hour, value: 4, to: start) ?? start
    }
}
