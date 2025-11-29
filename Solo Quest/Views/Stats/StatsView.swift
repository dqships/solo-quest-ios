//
//  StatsView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @Binding var path: NavigationPath

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.brandBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        if let user = viewModel.user {
                            NavigationLink(value: AppRoute.rankProgress(rank: user.rank, level: user.level)) {
                                StatsHeaderView(
                                    user: user,
                                    levelProgress: viewModel.levelProgress,
                                    currentLevelXP: viewModel.currentLevelXP,
                                    nextLevelXP: viewModel.nextLevelXP
                                )
                            }
                            .buttonStyle(.plain)

                            StatHexagonView(
                                userStats: user.stats,
                                statTaglines: viewModel.statTaglines,
                                onSelectStat: { _ in },
                                getRank: viewModel.getRank(from:)
                            )
                            .padding(.top, 40)
                        }

                        StatsDetailGridView(viewModel: viewModel)
                        Spacer(minLength: 40)
                    }
                    .padding(.top)
                }

                StatsOverlayLayer(viewModel: viewModel)
            }
            .navigationTitle("Stats")
            .navigationBarHidden(true)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .rankProgress(let rank, let level):
                    RankProgressView(currentRank: rank, currentLevel: level)
                case .statDetail(let statName, let currentXP, let tagline):
                    StatDetailView(
                        statName: statName,
                        currentXP: currentXP,
                        tagline: tagline,
                        viewModel: viewModel
                    )
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    StatsView(path: .constant(NavigationPath()))
}
