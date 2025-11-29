//
//  PenaltyRefreshIdentityProviding.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

@MainActor
protocol PenaltyRefreshIdentityProviding {
    func currentIdentity() -> PenaltyRefreshIdentitySnapshot
}
