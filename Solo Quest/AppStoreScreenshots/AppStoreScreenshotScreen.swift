//
//  AppStoreScreenshotScreen.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-29-2026
//

import Foundation
import SwiftUI

enum AppStoreScreenshotScreen: String, CaseIterable {
    case questOfTheDay = "1"
    case adventureAwaits = "2"
    case captureMemories = "3"
    case earnXPLevelUp = "4"
    case buildYourLore = "5"

    init?(argument: String?) {
        guard let argument else { return nil }

        if let screen = Self(rawValue: argument) {
            self = screen
            return
        }

        switch argument {
        case "quest-of-the-day":
            self = .questOfTheDay
        case "adventure-awaits":
            self = .adventureAwaits
        case "capture-memories":
            self = .captureMemories
        case "earn-xp-level-up":
            self = .earnXPLevelUp
        case "build-your-lore":
            self = .buildYourLore
        default:
            return nil
        }
    }

    var initialTab: MainTab {
        switch self {
        case .questOfTheDay, .adventureAwaits:
            return .quests
        case .captureMemories:
            return .log
        case .earnXPLevelUp:
            return .stats
        case .buildYourLore:
            return .log
        }
    }

    var initialStatsPath: NavigationPath {
        var path = NavigationPath()

        guard self == .earnXPLevelUp else { return path }

        path.append(AppRoute.statDetail(
            statName: "strength",
            currentXP: AppStoreScreenshotFixtureValues.strengthXP,
            tagline: LocalizationService.localizedStatTagline("strength")
        ))

        return path
    }
}
