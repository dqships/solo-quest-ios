//
//  PersonalityAssessmentViewModel+Results.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension PersonalityAssessmentViewModel {
    func calculateResults() {
        let result = PersonalityAssessmentScoring.calculateResult(
            questions: questions,
            answers: answers
        )

        calculatedStats = result.stats
        totalInitialXP = result.totalXP
        calculatedRank = result.rank
        calculatedLevel = result.level
    }
}
