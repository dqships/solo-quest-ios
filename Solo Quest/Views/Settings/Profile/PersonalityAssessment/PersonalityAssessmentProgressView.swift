//
//  PersonalityAssessmentProgressView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct PersonalityAssessmentProgressView: View {
    @ObservedObject var viewModel: PersonalityAssessmentViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rank & Level Assessment")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.brandBrownRich)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.3)
                        .foregroundColor(Color.brandBackground)

                    Rectangle()
                        .frame(width: min(CGFloat(viewModel.progress) * geometry.size.width, geometry.size.width), height: 8)
                        .foregroundColor(Color.brandBrownRich)
                        .animation(.linear, value: viewModel.progress)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)

            Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
                .font(.caption)
                .foregroundStyle(Color.brandBrownRich)
        }
    }
}
