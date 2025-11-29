//
//  PersonalityAssessmentQuestionCardView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct PersonalityAssessmentQuestionCardView: View {
    @ObservedObject var viewModel: PersonalityAssessmentViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.currentQuestion.text)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.brandDarkText)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 16) {
                ForEach(viewModel.shuffledOptions) { option in
                    Button {
                        viewModel.selectOption(option)
                    } label: {
                        Text(option.text)
                            .font(.body)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brandBrownRich)
                            .cornerRadius(12)
                            .foregroundColor(Color.brandBackground)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
