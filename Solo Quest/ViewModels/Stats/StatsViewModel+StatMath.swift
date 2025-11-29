//
//  StatsViewModel+StatMath.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension StatsViewModel {
    func getAttributeLevel(xp: Int) -> Int {
        questEngine.calculateLevel(xp: Int64(xp))
    }

    func getRank(from xp: Int) -> String {
        if xp < 500 { return "E" }
        if xp < 1500 { return "D" }
        if xp < 3000 { return "C" }
        if xp < 6000 { return "B" }
        if xp < 10000 { return "A" }
        return "S"
    }

    func getProgress(currentXP: Int) -> Double {
        let currentTierStart: Double
        let nextTierStart: Double

        if currentXP < 500 { currentTierStart = 0; nextTierStart = 500 }
        else if currentXP < 1500 { currentTierStart = 500; nextTierStart = 1500 }
        else if currentXP < 3000 { currentTierStart = 1500; nextTierStart = 3000 }
        else if currentXP < 6000 { currentTierStart = 3000; nextTierStart = 6000 }
        else if currentXP < 10000 { currentTierStart = 6000; nextTierStart = 10000 }
        else { return 1.0 }

        let progress = Double(currentXP) - currentTierStart
        let total = nextTierStart - currentTierStart
        return progress / total
    }

    func getNextTierXP(currentXP: Int) -> Int {
        if currentXP < 500 { return 500 }
        if currentXP < 1500 { return 1500 }
        if currentXP < 3000 { return 3000 }
        if currentXP < 6000 { return 6000 }
        if currentXP < 10000 { return 10000 }
        return 20000
    }
}
