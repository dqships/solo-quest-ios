//
//  QuestListViewModel+GameDayBoundary.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

extension QuestListViewModel {
    func gameDayBoundary(for localDate: Date, calendar: Calendar) -> Date? {
        var components = calendar.dateComponents(
            [.calendar, .timeZone, .year, .month, .day],
            from: localDate
        )
        components.hour = 4
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)
    }
}
