//
//  QuizQuestion.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let key: String
    let defaultText: String
    let options: [QuizOption]
    let primaryStat: String

    var text: String {
        LocalizationService.localizedQuizQuestion(key: key, fallback: defaultText)
    }
}
