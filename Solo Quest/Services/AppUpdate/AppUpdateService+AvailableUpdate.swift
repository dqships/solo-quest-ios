//
//  AppUpdateService+AvailableUpdate.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Foundation

extension AppUpdateService {
    func availableUpdate() async throws -> AppUpdateInfo? {
        guard let currentVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let bundleIdentifier = bundle.bundleIdentifier else {
            return nil
        }

        guard let appStoreVersion = try await latestAppStoreVersion(for: bundleIdentifier),
              isCurrentVersion(currentVersion, olderThan: appStoreVersion.version),
              let appStoreURL = appStoreVersion.trackViewUrl.flatMap(URL.init(string:))
                ?? appStoreVersion.trackId.flatMap({ URL(string: "https://apps.apple.com/app/id\($0)") }) else {
            return nil
        }

        let releaseNotes = appStoreVersion.releaseNotes?.trimmingCharacters(in: .whitespacesAndNewlines)

        return AppUpdateInfo(
            latestVersion: appStoreVersion.version,
            releaseNotes: releaseNotes?.isEmpty == true ? nil : releaseNotes,
            appStoreURL: appStoreURL
        )
    }
}
