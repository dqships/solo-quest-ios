//
//  ActivityLogItemMapper.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum ActivityLogItemMapper {
    static func make(from entity: ActivityLog) -> ActivityLogItem {
        ActivityLogItem(
            id: entity.id?.uuidString ?? UUID().uuidString,
            date: ISO8601DateFormatter().string(from: entity.date ?? Date()),
            type: "log",
            questId: entity.questInstanceId?.uuidString,
            deltaByStat: [:],
            totalDelta: Int(entity.xpDelta),
            note: entity.note ?? "",
            details: entity.details
        )
    }
}
