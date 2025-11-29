//
//  LevelConfig.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct LevelConfig: Codable {
    let maxLevel: Int
    let baseXPPerLevel: Int
    let xpExponent: Double
}
