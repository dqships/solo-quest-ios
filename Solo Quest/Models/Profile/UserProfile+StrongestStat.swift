//
//  UserProfile+StrongestStat.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension UserProfile {
    var strongestStatName: String {
        [
            (String(localized: "Luck"), stats.luck),
            (String(localized: "Charisma"), stats.charisma),
            (String(localized: "Strength"), stats.strength),
            (String(localized: "Stamina"), stats.stamina),
            (String(localized: "Resilience"), stats.resilience),
            (String(localized: "Intelligence"), stats.intelligence)
        ].max { $0.1 < $1.1 }?.0 ?? String(localized: "Resilience")
    }
}
