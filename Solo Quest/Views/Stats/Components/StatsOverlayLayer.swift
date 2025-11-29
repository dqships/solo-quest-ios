//
//  StatsOverlayLayer.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatsOverlayLayer: View {
    @ObservedObject var viewModel: StatsViewModel

    var body: some View {
        ZStack {
            if viewModel.showLevelUpAnimation {
                LevelUpOverlayView(
                    previousLevel: viewModel.previousLevel,
                    newLevel: viewModel.newLevel,
                    onDismiss: {
                        viewModel.markLevelUpSeen()
                    }
                )
                .transition(.opacity)
                .zIndex(100)
            }

            if viewModel.showRankUpAnimation {
                RankUpOverlayView(
                    previousRank: viewModel.previousRank,
                    newRank: viewModel.newRank,
                    onDismiss: {
                        viewModel.markRankUpSeen()
                    }
                )
                .transition(.opacity)
                .zIndex(101)
            }
        }
    }
}
