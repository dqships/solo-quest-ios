//
//  PenaltyRefreshTestIdentityProvider.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

@testable import Solo_Quest

@MainActor
final class PenaltyRefreshTestIdentityProvider: PenaltyRefreshIdentityProviding {
    var identity: PenaltyRefreshIdentitySnapshot

    init(identity: PenaltyRefreshIdentitySnapshot) {
        self.identity = identity
    }

    func currentIdentity() -> PenaltyRefreshIdentitySnapshot {
        identity
    }
}
