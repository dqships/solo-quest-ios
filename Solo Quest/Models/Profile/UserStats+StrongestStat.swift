//
//  UserStats+StrongestStat.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension UserStats {
    var strongestStat: (name: String, xp: Int64) {
        [
            (String(localized: "Luck"), luckXP),
            (String(localized: "Charisma"), charismaXP),
            (String(localized: "Strength"), strengthXP),
            (String(localized: "Stamina"), staminaXP),
            (String(localized: "Resilience"), resilienceXP),
            (String(localized: "Intelligence"), intelligenceXP)
        ].max { $0.1 < $1.1 } ?? (String(localized: "Resilience"), 0)
    }
}
