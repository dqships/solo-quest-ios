//
//  SocialIntensity+ConstraintRank.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

extension SocialIntensity {
    var constraintRank: Int {
        switch self {
        case .solo, .strangers_optional: return 0
        case .one_on_one: return 1
        case .small_group: return 2
        case .strangers_required: return 3
        }
    }
}
