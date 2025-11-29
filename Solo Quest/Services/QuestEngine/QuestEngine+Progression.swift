//
//  QuestEngine+Progression.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension QuestEngine {
    func getLevelProgress(totalXP: Int64) -> (currentLevelXP: Int64, nextLevelXP: Int64, progress: Double) {
        guard let config = gameData?.config.levelConfig else { return (0, 1, 0) }

        let base = Double(config.baseXPPerLevel)
        let exponent = config.xpExponent
        let constant = base / (exponent - 1.0)

        let totalXPDouble = Double(totalXP)
        let currentLevelDouble = 1.0 + (log(totalXPDouble / constant + 1.0) / log(exponent))
        let currentLevel = floor(currentLevelDouble)

        let currentLevelStartXP = constant * (pow(exponent, currentLevel - 1.0) - 1.0)
        let nextLevelStartXP = constant * (pow(exponent, currentLevel) - 1.0)

        let range = nextLevelStartXP - currentLevelStartXP
        let currentProgress = totalXPDouble - currentLevelStartXP

        let progressFraction = range > 0 ? currentProgress / range : 0.0

        return (
            currentLevelXP: Int64(currentProgress),
            nextLevelXP: Int64(range),
            progress: min(max(progressFraction, 0.0), 1.0)
        )
    }

    func isProtectedFromDailyInactivityPenalty(userStats _: UserStats) -> Bool {
        storeKit.isPro
    }

    func applyStatXP(to stats: UserStats, stat: String?, amount: Int64) {
        guard let stat = stat?.lowercased() else { return }
        switch stat {
        case "luck": stats.luckXP += amount
        case "charisma": stats.charismaXP += amount
        case "strength": stats.strengthXP += amount
        case "stamina": stats.staminaXP += amount
        case "resilience": stats.resilienceXP += amount
        case "intelligence": stats.intelligenceXP += amount
        default: break
        }
    }

    func calculateLevel(xp: Int64) -> Int {
        guard let config = gameData?.config.levelConfig else { return 1 }

        let base = Double(config.baseXPPerLevel)
        let exponent = config.xpExponent

        if exponent <= 1.0 {
            return Int(xp / Int64(base)) + 1
        }

        let constant = base / (exponent - 1.0)
        let xpDouble = Double(xp)

        let levelDouble = 1.0 + (log(xpDouble / constant + 1.0) / log(exponent))
        let newLevel = Int(floor(levelDouble))

        return min(newLevel, config.maxLevel)
    }

    func checkLevelUp(_ stats: UserStats) {
        guard gameData?.config.levelConfig != nil else { return }

        let oldLevel = stats.level
        let oldRank = stats.rank

        stats.level = Int16(calculateLevel(xp: stats.totalXP))

        if let ranks = gameData?.config.ranks {
            if let matchingRank = ranks.first(where: { Int(stats.level) >= $0.minLevel && Int(stats.level) <= $0.maxLevel }) {
                stats.rank = matchingRank.id
            } else {
                stats.rank = "E"
            }
        }

        if stats.level > oldLevel {
            analytics.trackLevelUp(newLevel: stats.level, totalXP: stats.totalXP)
        }

        if stats.rank != oldRank {
            analytics.trackRankUp(newRank: stats.rank ?? "E")
        }
    }
}
