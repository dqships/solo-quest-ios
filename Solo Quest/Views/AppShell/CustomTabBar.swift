//
//  CustomTabBar.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Clerk
import Factory
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: MainTabView.Tab
    @Binding var edge: Edge
    @Binding var showAuthSheet: Bool
    @Environment(\.clerk) private var clerk
    @Injected(\.analyticsManager) private var analytics
    var onReselect: (MainTabView.Tab) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.brandNeutral.opacity(0.3))

            HStack {
                ForEach(MainTabView.Tab.allCases, id: \.self) { tab in
                    Button {
                        handleTap(tab)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 24))
                            Text(tab.title)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(selectedTab == tab ? .brandBrownRich : .gray)
                        .contentShape(Rectangle())
                    }
                }
            }
            .background(
                Color.brandBackground
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }

    private func handleTap(_ tab: MainTabView.Tab) {
        if selectedTab == tab {
            onReselect(tab)
            return
        }

        if (tab == .stats || tab == .log) && ClerkConfiguration.requiresSignIn(user: clerk.user) {
            showAuthSheet = true
            return
        }

        edge = tab.rawValue > selectedTab.rawValue ? .trailing : .leading

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0)) {
            selectedTab = tab
            analytics.trackTabChanged(tabName: tab.title)
        }
    }
}
