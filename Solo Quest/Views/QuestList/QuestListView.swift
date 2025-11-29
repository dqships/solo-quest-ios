//
//  QuestListView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Clerk

struct QuestListView: View {
    @StateObject private var viewModel = QuestListViewModel()
    @Binding var path: NavigationPath
    @State private var showStoreSheet = false
    @State private var showAuthSheet = false
    @State private var showSettingsSheet = false
    @State private var showPreferencesSheet = false
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                ZStack {
                    Color.brandBackground
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            QuestListHeaderActionRow(
                                showSettings: { showSettingsSheet = true }
                            )
                            
                            DailyQuestSectionView(
                                viewModel: viewModel,
                                showPreferences: { showPreferencesSheet = true }
                            )
                            
                            if let user = viewModel.user {
                                QuestListRecentActivitySectionView(
                                    viewModel: viewModel,
                                    activityLog: user.activityLog
                                )
                                .frame(maxWidth: 600)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.top)
                    }
                    
                    QuestListModalOverlayView(viewModel: viewModel)
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .rankProgress(let rank, let level):
                        RankProgressView(currentRank: rank, currentLevel: level)
                    case .questDetail(let instance, let template):
                        QuestDetailView(
                            instance: instance,
                            template: template,
                            onAccept: { quest in viewModel.acceptQuest(quest) },
                            onComplete: { quest in viewModel.completeQuest(quest) },
                            onFail: { quest in viewModel.failQuest(quest) }
                        )
                    case .activityDetail(let item):
                        ActivityDetailView(activityItem: item)
                    default:
                        EmptyView()
                    }
                }
            }
            .sheet(isPresented: $showStoreSheet) {
                StoreView(source: viewModel.storeSource)
            }
            .onChange(of: viewModel.openStoreSheet) { _, shouldOpen in
                if shouldOpen {
                    showStoreSheet = true
                    viewModel.openStoreSheet = false
                }
            }
            .sheet(isPresented: $showAuthSheet) {
                AuthView()
            }
            .onChange(of: viewModel.openAuthSheet) { _, shouldOpen in
                if shouldOpen {
                    showAuthSheet = true
                    viewModel.openAuthSheet = false
                }
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView()
            }
            .sheet(isPresented: $showPreferencesSheet) {
                QuestPreferencesView()
            }
            .sheet(item: $viewModel.completionReward) { reward in
                CompletionRewardSummaryView(
                    reward: reward,
                    hasMoreAvailableQuests: viewModel.dailyQuests.contains { $0.state == "available" },
                    dismiss: viewModel.dismissCompletionReward
                )
                .presentationDetents([.large])
            }
            
            if viewModel.showToast {
                ToastView(
                    message: viewModel.toastMessage,
                    actionTitle: viewModel.toastActionTitle,
                    action: {
                        viewModel.toastAction?()
                        withAnimation { viewModel.showToast = false }
                    },
                    onDismiss: {
                        withAnimation { viewModel.showToast = false }
                    }
                )
            }
            
            if let animation = viewModel.activeAnimation {
                QuestCardAnimationView(
                    type: animationType(for: animation),
                    onFinished: viewModel.finishAnimation
                )
            }
        }
    }
}

#Preview {
    QuestListView(path: .constant(NavigationPath()))
}
