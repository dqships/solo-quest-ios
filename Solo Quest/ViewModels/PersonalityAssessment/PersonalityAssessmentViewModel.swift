//
//  PersonalityAssessmentViewModel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Combine
import Factory
import SwiftUI

@MainActor
class PersonalityAssessmentViewModel: ObservableObject {
    @Injected(\.userStatsManager) private var userStatsManager

    @Published var currentQuestionIndex = 0
    @Published var answers: [String: Int] = [:]
    @Published var isComplete = false
    @Published var calculatedStats: [String: Int64] = [:]
    @Published var totalInitialXP: Int64 = 0
    @Published var calculatedRank: String = "E"
    @Published var calculatedLevel: Int16 = 1
    @Published var shuffledOptions: [QuizOption] = []

    let questions = QuizData.questions

    var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }

    var progress: Double {
        Double(currentQuestionIndex) / Double(questions.count)
    }

    init() {
        updateShuffledOptions()
    }

    func applyStats() {
        userStatsManager.initializeStats(with: calculatedStats)
    }
}
