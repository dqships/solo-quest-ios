//
//  AppRuntimeMode.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

enum AppRuntimeMode {
    static var isRunningXCTest: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
