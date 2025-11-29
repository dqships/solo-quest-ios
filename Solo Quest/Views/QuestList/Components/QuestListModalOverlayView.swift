//
//  QuestListModalOverlayView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestListModalOverlayView: View {
    @ObservedObject var viewModel: QuestListViewModel
    
    var body: some View {
        if let modal = viewModel.activeModal {
            GenericModalView {
                switch modal {
                case .dailySkip(let penalty):
                    DailySkipModal(penaltyXP: penalty) {
                        withAnimation { viewModel.dismissModal() }
                    }
                case .questFailure(let reason, let penalty):
                    QuestFailureModal(reason: reason, penaltyXP: penalty) {
                        withAnimation { viewModel.dismissModal() }
                    }
                case .rankDown(let old, let new, let level):
                    RankDownModal(oldRank: old, newRank: new, currentLevel: level) {
                        withAnimation { viewModel.dismissModal() }
                    }
                }
            }
        }
    }
}
