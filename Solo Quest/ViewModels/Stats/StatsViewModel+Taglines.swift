//
//  StatsViewModel+Taglines.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension StatsViewModel {
    var statTaglines: [String: String] {
        [
            "luck": LocalizationService.localizedStatTagline("luck"),
            "charisma": LocalizationService.localizedStatTagline("charisma"),
            "strength": LocalizationService.localizedStatTagline("strength"),
            "stamina": LocalizationService.localizedStatTagline("stamina"),
            "resilience": LocalizationService.localizedStatTagline("resilience"),
            "intelligence": LocalizationService.localizedStatTagline("intelligence")
        ]
    }
}
