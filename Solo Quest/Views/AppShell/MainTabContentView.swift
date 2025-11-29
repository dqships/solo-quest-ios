//
//  MainTabContentView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct MainTabContentView: View {
    let selectedTab: MainTab
    let edge: Edge
    @Binding var questsPath: NavigationPath
    @Binding var statsPath: NavigationPath
    @Binding var logPath: NavigationPath
    let questsResetID: UUID
    let statsResetID: UUID
    let logResetID: UUID

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .quests:
                    QuestListView(path: $questsPath)
                        .id(questsResetID)
                case .log:
                    AdventureLogView(path: $logPath)
                        .id(logResetID)
                case .stats:
                    StatsView(path: $statsPath)
                        .id(statsResetID)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(
                .asymmetric(
                    insertion: .move(edge: edge).combined(with: .opacity),
                    removal: .move(edge: edge == .leading ? .trailing : .leading).combined(with: .opacity)
                )
            )
            .id(selectedTab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brandBackground.ignoresSafeArea())
    }
}
