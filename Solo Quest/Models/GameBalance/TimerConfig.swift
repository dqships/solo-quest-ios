//
//  TimerConfig.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct TimerConfig: Codable {
    let completionUnlockSeconds: Int
    let autoFailOnExpire: Bool
}
