//
//  AppStoreScreenshotRootView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-29-2026
//

import SwiftUI

struct AppStoreScreenshotRootView: View {
    let screen: AppStoreScreenshotScreen

    var body: some View {
        switch screen {
        case .questOfTheDay, .adventureAwaits, .captureMemories, .earnXPLevelUp:
            MainTabView(
                initialTab: screen.initialTab,
                statsPath: screen.initialStatsPath
            )
        case .buildYourLore:
            AppStoreScreenshotLoreImageView()
        }
    }
}
