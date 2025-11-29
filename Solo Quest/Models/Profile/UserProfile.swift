//
//  UserProfile.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation

struct UserProfile: Codable, Equatable, Hashable {
    let userId: String
    let rank: String
    let level: Int
    let totalXp: Int
    let streakDays: Int
    let sideQuestCredits: Int
    let stats: UserStatBlock
    let activityLog: [ActivityLogItem]

    static func empty() -> UserProfile {
        return UserProfile(
            userId: "",
            rank: "E",
            level: 1,
            totalXp: 0,
            streakDays: 0,
            sideQuestCredits: 0,
            stats: UserStatBlock(luck: 0, charisma: 0, strength: 0, stamina: 0, resilience: 0, intelligence: 0),
            activityLog: []
        )
    }
}
