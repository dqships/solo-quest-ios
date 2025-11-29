//
//  QuestListViewModel+Accessors.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension QuestListViewModel {
    func getTemplate(for questId: String) -> QuestTemplate? {
        questEngine.getTemplate(id: questId)
    }
}
