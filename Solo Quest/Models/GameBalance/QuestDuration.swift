//
//  QuestDuration.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct QuestDuration: Codable {
    let minMinutes: Int
    let maxMinutes: Int
    let defaultTimerMinutes: Int
}
