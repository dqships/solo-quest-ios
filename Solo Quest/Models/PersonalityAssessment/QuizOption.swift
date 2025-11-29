//
//  QuizOption.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct QuizOption: Identifiable {
    let id = UUID()
    let key: String
    let defaultText: String
    let score: Int

    var text: String {
        LocalizationService.localizedQuizOption(key: key, fallback: defaultText)
    }
}
