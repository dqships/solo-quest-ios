//
//  AppUpdateService+VersionComparison.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Foundation

extension AppUpdateService {
    func isCurrentVersion(_ currentVersion: String, olderThan latestVersion: String) -> Bool {
        latestVersion.compare(currentVersion, options: .numeric) == .orderedDescending
    }
}
