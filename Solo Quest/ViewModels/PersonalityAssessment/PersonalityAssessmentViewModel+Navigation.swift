//
//  PersonalityAssessmentViewModel+Navigation.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

extension PersonalityAssessmentViewModel {
    func selectOption(_ option: QuizOption) {
        answers[currentQuestion.id.uuidString] = option.score

        if currentQuestionIndex < questions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
                updateShuffledOptions()
            }
        } else {
            calculateResults()
            withAnimation {
                isComplete = true
            }
        }
    }

    func previousQuestion() {
        if currentQuestionIndex > 0 {
            withAnimation {
                currentQuestionIndex -= 1
                updateShuffledOptions()
            }
        }
    }

    func updateShuffledOptions() {
        shuffledOptions = currentQuestion.options.shuffled()
    }
}
