//
//  SoloQuestNotificationType.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

enum SoloQuestNotificationType: String {
    case freshBoard = "fresh_board"
    case activeQuest = "active_quest"
    case nearLevelUp = "near_level_up"
    case returnAfterInactivity = "return_after_inactivity"
    case weeklyRecap = "weekly_recap"

    var requestIdentifier: String { "solo_quest_\(rawValue)" }

    static var allRequestIdentifiers: [String] {
        [freshBoard, activeQuest, nearLevelUp, returnAfterInactivity, weeklyRecap].map(\.requestIdentifier)
    }
}
