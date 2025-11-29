//
//  QuestEngine+XPRewards.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-17-2026
//

import Foundation

extension QuestEngine {
    var xpRewardMultiplier: Int64 {
        storeKit.isPro ? 2 : 1
    }

    var isDoubleXPActive: Bool {
        xpRewardMultiplier > 1
    }

    func awardedXP(for quest: QuestInstance) -> Int64 {
        awardedXP(forBaseXP: Int64(quest.xpReward))
    }


    func awardedXP(forBaseXP baseXP: Int64) -> Int64 {
        baseXP * xpRewardMultiplier
    }
}
