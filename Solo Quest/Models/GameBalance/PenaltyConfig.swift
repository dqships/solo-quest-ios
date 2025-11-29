//
//  PenaltyConfig.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct PenaltyConfig: Codable {
    let dailySkipPenaltyRate: Double
    let questFailPenaltyRate: Double
    let minTotalXP: Int
}
