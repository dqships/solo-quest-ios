//
//  UserProfileMapper.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation

enum UserProfileMapper {
    static func make(stats: UserStats, activityLog: [ActivityLogItem]) -> UserProfile {
        UserProfile(
            userId: "real_user",
            rank: stats.rank ?? "E",
            level: Int(stats.level),
            totalXp: Int(stats.totalXP),
            streakDays: Int(stats.currentStreak),
            sideQuestCredits: Int(stats.sideQuestCredits),
            stats: UserStatBlock(
                luck: Int(stats.luckXP),
                charisma: Int(stats.charismaXP),
                strength: Int(stats.strengthXP),
                stamina: Int(stats.staminaXP),
                resilience: Int(stats.resilienceXP),
                intelligence: Int(stats.intelligenceXP)
            ),
            activityLog: activityLog
        )
    }
}
