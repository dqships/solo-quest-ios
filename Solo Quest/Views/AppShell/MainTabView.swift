//
//  MainTabView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Factory
import Clerk
import SwiftUI

struct MainTabView: View {
    typealias Tab = MainTab

    @ObservedObject private var notificationManager = Container.shared.notificationManager()
    @State private var showAuthSheet = false
    @State private var selectedTab: Tab
    @State private var edge: Edge = .trailing
    @State private var questsResetID = UUID()
    @State private var statsResetID = UUID()
    @State private var logResetID = UUID()
    @State private var questsPath = NavigationPath()
    @State private var statsPath: NavigationPath
    @State private var logPath = NavigationPath()

    init(initialTab: Tab = .quests, statsPath: NavigationPath = NavigationPath()) {
        _selectedTab = State(initialValue: initialTab)
        _statsPath = State(initialValue: statsPath)
    }

    var body: some View {
        VStack(spacing: 0) {
            MainTabContentView(
                selectedTab: selectedTab,
                edge: edge,
                questsPath: $questsPath,
                statsPath: $statsPath,
                logPath: $logPath,
                questsResetID: questsResetID,
                statsResetID: statsResetID,
                logResetID: logResetID
            )

            CustomTabBar(
                selectedTab: $selectedTab,
                edge: $edge,
                showAuthSheet: $showAuthSheet,
                onReselect: resetTabIfNeeded
            )
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAuthSheet) {
            AuthView()
        }
        .onChange(of: notificationManager.pendingDestination) { _, destination in
            guard let destination else { return }
            selectedTab = destination
            if destination == .quests {
                questsPath = NavigationPath()
                questsResetID = UUID()
            } else if destination == .stats {
                statsPath = NavigationPath()
                statsResetID = UUID()
            }
            notificationManager.pendingDestination = nil
        }
    }

    private func resetTabIfNeeded(_ tab: Tab) {
        var shouldReset = false

        switch tab {
        case .quests:
            if !questsPath.isEmpty { shouldReset = true }
        case .log:
            if !logPath.isEmpty { shouldReset = true }
        case .stats:
            if !statsPath.isEmpty { shouldReset = true }
        }

        guard shouldReset else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0)) {
            switch tab {
            case .quests:
                questsPath = NavigationPath()
                questsResetID = UUID()
            case .log:
                logPath = NavigationPath()
                logResetID = UUID()
            case .stats:
                statsPath = NavigationPath()
                statsResetID = UUID()
            }
        }
    }
}

#Preview {
    MainTabView()
}
