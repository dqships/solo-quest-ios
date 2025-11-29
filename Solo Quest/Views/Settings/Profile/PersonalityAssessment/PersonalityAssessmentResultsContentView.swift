//
//  PersonalityAssessmentResultsContentView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct PersonalityAssessmentResultsContentView: View {
    @ObservedObject var viewModel: PersonalityAssessmentViewModel
    let onFinished: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 20)
                PersonalityAssessmentCompleteHeaderView()
                PersonalityAssessmentRankCardView(
                    rank: viewModel.calculatedRank,
                    level: viewModel.calculatedLevel
                )
                PersonalityAssessmentStrengthsCardView(stats: viewModel.calculatedStats)
                Spacer(minLength: 100)
            }
        }
        .overlay(alignment: .bottom) {
            PersonalityAssessmentContinueButton {
                viewModel.applyStats()
                onFinished()
            }
        }
    }
}
