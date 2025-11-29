//
//  QuestDisplayable.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

protocol QuestDisplayable: Identifiable {
    var id: String { get }
    var questTemplateId: String? { get }
    var state: String? { get }
}

extension QuestInstance {}
