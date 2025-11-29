//
//  GameDayIdentifier.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

enum GameDayIdentifier {
    static func make(gameDayStart: Date, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy-MM-dd"

        return "\(calendar.timeZone.identifier)|\(formatter.string(from: gameDayStart))"
    }
}
