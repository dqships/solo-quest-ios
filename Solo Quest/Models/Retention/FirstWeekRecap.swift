//
//  FirstWeekRecap.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

struct FirstWeekRecap: Identifiable {
    let id = UUID()
    let questsCompleted: Int
    let activeDays: Int
    let xpEarned: Int
    let strongestStat: String
    let strongestStatXP: Int
    let level: Int
    let rank: String
    let memoriesCreated: Int
}
