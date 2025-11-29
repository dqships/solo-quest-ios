//
//  MainTab.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum MainTab: Int, CaseIterable {
    case quests = 0
    case log = 1
    case stats = 2

    var title: String {
        switch self {
        case .quests: return String(localized: "Quests")
        case .log: return String(localized: "Log")
        case .stats: return String(localized: "Stats")
        }
    }

    var icon: String {
        switch self {
        case .quests: return "scroll.fill"
        case .log: return "photo.stack.fill"
        case .stats: return "chart.bar.fill"
        }
    }
}
