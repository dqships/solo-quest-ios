//
//  ActivityLogItem.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct ActivityLogItem: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let date: String
    let type: String
    let questId: String?
    let deltaByStat: [String: Int]
    let totalDelta: Int
    let note: String
    let details: String?
}

extension ActivityLogItem {
    var localizedNote: String {
        note
    }
}
