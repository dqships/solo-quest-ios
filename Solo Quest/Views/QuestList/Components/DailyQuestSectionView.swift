//
//  DailyQuestSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI
import Clerk

struct DailyQuestSectionView: View {
    @ObservedObject var viewModel: QuestListViewModel
    @Environment(\.clerk) private var clerk
    let showPreferences: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today's Quests")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.brandDarkText)
                
                Spacer()
                
                Button(action: showPreferences) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.brandBrownRich)
                        
                        if QuestFilterPreferences.load().hasAnyPreferences {
                            Circle()
                                .fill(Color.brandAccentOrange)
                                .frame(width: 8, height: 8)
                                .offset(x: 2, y: -2)
                        }
                    }
                }
                
                Button(action: rerollQuests) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.canReroll || !ClerkConfiguration.requiresSignIn(user: clerk.user) ? .brandAccentOrange : .brandTextSecondary.opacity(0.5))
                }
            }
            .padding(.horizontal)

            FirstWeekJourneyCard(user: viewModel.user)

            if viewModel.questEngine.newPlayerProtection.isActive() {
                NoviceProtectionBannerView(
                    daysRemaining: viewModel.questEngine.newPlayerProtection.daysRemaining()
                )
            }
            
            if viewModel.dailyQuests.isEmpty {
                VStack(spacing: 12) {
                    Text("No suitable quests are available right now.")
                        .multilineTextAlignment(.center)
                    Button("Adjust quest preferences", action: showPreferences)
                        .buttonStyle(.bordered)
                        .tint(.brandBrownRich)
                }
                    .padding(.horizontal)
                    .foregroundColor(.brandTextSecondary)
                    .frame(height: 400)
            } else {
                TabView {
                    ForEach(viewModel.dailyQuests) { instance in
                        NavigationLink(value: AppRoute.questDetail(
                            instance: instance,
                            template: viewModel.getTemplate(for: instance.questTemplateId ?? "")
                        )) {
                            FantasyQuestCard(
                                instance: instance,
                                template: viewModel.getTemplate(for: instance.questTemplateId ?? ""),
                                onAccept: { quest in viewModel.acceptQuest(quest) },
                                onComplete: { quest in viewModel.completeQuest(quest) },
                                onFail: { quest in viewModel.failQuest(quest) }
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 8)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(height: 560)
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if !viewModel.canReroll {
                Group {
                    if ClerkConfiguration.requiresSignIn(user: clerk.user) {
                        Text("Sign in to buy rerolls.")
                    } else {
                        Text(viewModel.dailyQuests.contains { $0.state == "active" || $0.state == "locked" }
                             ? "Finish active quests before rerolling."
                             : "No rerolls available.")
                    }
                }
                .font(.caption)
                .foregroundColor(.brandTextSecondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, -8)
            }
        }
        .confirmationDialog("What did not fit today?", isPresented: $viewModel.isShowingRerollReasons, titleVisibility: .visible) {
            ForEach(RerollReason.allCases) { reason in
                Button(reason.title) {
                    viewModel.rerollQuests(reason: reason)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func rerollQuests() {
        viewModel.requestReroll()
        if ClerkConfiguration.requiresSignIn(user: clerk.user) {
            viewModel.openAuthSheet = true
        } else if viewModel.dailyQuests.contains(where: { $0.state == "active" || $0.state == "locked" }) {
            viewModel.showToast = true
            viewModel.toastMessage = String(localized: "Finish your current quest before rerolling.")
            viewModel.toastActionTitle = nil
            viewModel.toastAction = nil
        } else {
            viewModel.isShowingRerollReasons = true
        }
    }
}
