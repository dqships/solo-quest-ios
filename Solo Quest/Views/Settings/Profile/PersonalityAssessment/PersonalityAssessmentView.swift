//
//  PersonalityAssessmentView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct PersonalityAssessmentView: View {
    @StateObject private var viewModel = PersonalityAssessmentViewModel()
    let onFinished: () -> Void

    var body: some View {
        VStack {
            if !viewModel.isComplete {
                PersonalityAssessmentQuizContentView(viewModel: viewModel, onCancel: onFinished)
            } else {
                PersonalityAssessmentResultsContentView(viewModel: viewModel, onFinished: onFinished)
            }
        }
        .animation(.easeInOut, value: viewModel.currentQuestionIndex)
        .animation(.easeInOut, value: viewModel.isComplete)
    }
}
