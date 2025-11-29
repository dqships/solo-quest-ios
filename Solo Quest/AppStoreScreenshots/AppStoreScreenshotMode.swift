//
//  AppStoreScreenshotMode.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-29-2026
//

import Foundation

enum AppStoreScreenshotMode {
    private static let enabledArgument = "-SoloQuestAppStoreScreenshotMode"
    private static let screenArgument = "-SoloQuestAppStoreScreenshotScreen"

    static var isEnabled: Bool {
        #if DEBUG
        ProcessInfo.processInfo.arguments.contains(enabledArgument)
        #else
        false
        #endif
    }

    static var screen: AppStoreScreenshotScreen {
        #if DEBUG
        AppStoreScreenshotScreen(argument: value(after: screenArgument)) ?? .questOfTheDay
        #else
        .questOfTheDay
        #endif
    }

    private static func value(after argumentName: String) -> String? {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: argumentName) else { return nil }

        let valueIndex = arguments.index(after: index)
        guard arguments.indices.contains(valueIndex) else { return nil }

        return arguments[valueIndex]
    }
}
