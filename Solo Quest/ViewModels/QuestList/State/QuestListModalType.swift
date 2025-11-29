//
//  QuestListModalType.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum QuestListModalType: Identifiable {
    case dailySkip(penalty: Int)
    case questFailure(reason: QuestFailureModal.FailReason, penalty: Int)
    case rankDown(old: String, new: String, level: Int)

    var id: String {
        switch self {
        case .dailySkip: return "dailySkip"
        case .questFailure: return "questFailure"
        case .rankDown: return "rankDown"
        }
    }
}
