//
//  SideQuestRules.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct SideQuestRules: Codable {
    let bundleSize: Int
    let applySkipPenalty: Bool
    let applyFailPenalty: Bool
    let maxBundlesPerDay: Int
}
