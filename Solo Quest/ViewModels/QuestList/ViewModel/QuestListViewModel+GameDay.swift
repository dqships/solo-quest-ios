//
//  QuestListViewModel+GameDay.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension QuestListViewModel {
    func currentGameDayBounds(now: Date = Date()) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let localDay = calendar.startOfDay(for: now)
        let boundaryToday = gameDayBoundary(for: localDay, calendar: calendar) ?? localDay
        let gameDayDate = now < boundaryToday ? calendar.date(byAdding: .day, value: -1, to: localDay) ?? localDay : localDay
        let start = gameDayBoundary(for: gameDayDate, calendar: calendar) ?? gameDayDate
        let nextDate = calendar.date(byAdding: .day, value: 1, to: gameDayDate) ?? gameDayDate
        let end = gameDayBoundary(for: nextDate, calendar: calendar) ?? start
        return (start, end)
    }

    func sortScore(for state: String?) -> Int {
        switch state {
        case "active", "locked": return 0
        case "available": return 1
        default: return 2
        }
    }
}
