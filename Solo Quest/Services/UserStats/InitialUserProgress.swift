//
//  InitialUserProgress.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct InitialUserProgress {
    let rank: String
    let level: Int16

    static func calculate(totalXP: Int64) -> InitialUserProgress {
        if totalXP < 3375 {
            return InitialUserProgress(rank: "E", level: Int16(1 + (totalXP / 178)))
        } else if totalXP < 14500 {
            return InitialUserProgress(rank: "D", level: Int16(20 + ((totalXP - 3375) / 557)))
        } else if totalXP < 47275 {
            return InitialUserProgress(rank: "C", level: Int16(40 + ((totalXP - 14500) / 1725)))
        } else if totalXP < 140000 {
            return InitialUserProgress(rank: "B", level: Int16(59 + ((totalXP - 47275) / 5153)))
        } else if totalXP < 355700 {
            return InitialUserProgress(rank: "A", level: Int16(77 + ((totalXP - 140000) / 13481)))
        } else {
            return InitialUserProgress(rank: "S", level: Int16(min(93 + ((totalXP - 355700) / 27000), 100)))
        }
    }
}
