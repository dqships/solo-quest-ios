//
//  PersonalityAssessmentScoring.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum PersonalityAssessmentScoring {
    static func calculateResult(
        questions: [QuizQuestion],
        answers: [String: Int]
    ) -> PersonalityAssessmentResult {
        var statXP: [String: Int64] = [
            "luck": 0,
            "charisma": 0,
            "strength": 0,
            "stamina": 0,
            "resilience": 0,
            "intelligence": 0
        ]

        for question in questions {
            let questionID = question.id.uuidString
            if let score = answers[questionID] {
                statXP[question.primaryStat, default: 0] += Int64(score)
            }
        }

        let cappedStats = capStartingXP(statXP)
        let totalXP = cappedStats.values.reduce(0, +)
        let progress = calculateProgress(totalXP: totalXP)

        return PersonalityAssessmentResult(
            stats: cappedStats,
            totalXP: totalXP,
            rank: progress.rank,
            level: progress.level
        )
    }

    private static func capStartingXP(_ statXP: [String: Int64]) -> [String: Int64] {
        let totalXP = statXP.values.reduce(0, +)
        let maxStartingXP: Int64 = 12500

        guard totalXP > maxStartingXP else {
            return statXP
        }

        let scale = Double(maxStartingXP) / Double(totalXP)
        return statXP.mapValues { xp in
            Int64(Double(xp) * scale)
        }
    }

    private static func calculateProgress(totalXP: Int64) -> InitialUserProgress {
        if totalXP < 3375 {
            return InitialUserProgress(rank: "E", level: Int16(1 + (totalXP / 178)))
        } else if totalXP < 14500 {
            return InitialUserProgress(rank: "D", level: Int16(20 + ((totalXP - 3375) / 557)))
        } else {
            return InitialUserProgress(rank: "C", level: 40)
        }
    }
}
