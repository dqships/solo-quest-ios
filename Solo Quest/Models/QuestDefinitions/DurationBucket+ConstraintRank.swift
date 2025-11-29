//
//  DurationBucket+ConstraintRank.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension DurationBucket {
    var constraintRank: Int {
        switch self {
        case .short_5_15: return 0
        case .medium_15_30: return 1
        case .long_30_60: return 2
        case .marathon_60_plus: return 3
        }
    }
}
