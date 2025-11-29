//
//  CostLevel+ConstraintRank.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension CostLevel {
    var constraintRank: Int {
        switch self {
        case .free: return 0
        case .cheap: return 1
        case .moderate: return 2
        case .expensive: return 3
        }
    }
}
