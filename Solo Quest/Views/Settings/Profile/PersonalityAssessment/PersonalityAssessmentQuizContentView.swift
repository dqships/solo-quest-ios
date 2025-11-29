//
//  PersonalityAssessmentQuizContentView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct PersonalityAssessmentQuizContentView: View {
    @ObservedObject var viewModel: PersonalityAssessmentViewModel
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            PersonalityAssessmentProgressView(viewModel: viewModel)
                .padding(.top)
                .padding(.horizontal)

            Spacer()

            PersonalityAssessmentQuestionCardView(viewModel: viewModel)
                .padding()

            Spacer()

            HStack {
                Button("Back") {
                    if viewModel.currentQuestionIndex > 0 {
                        viewModel.previousQuestion()
                    } else {
                        onCancel()
                    }
                }
                .foregroundStyle(.secondary)
                .foregroundColor(.brandDarkText)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
    }
}
