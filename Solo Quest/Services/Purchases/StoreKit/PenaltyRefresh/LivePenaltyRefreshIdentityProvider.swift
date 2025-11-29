//
//  LivePenaltyRefreshIdentityProvider.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Clerk
import Foundation
import RevenueCat

@MainActor
final class LivePenaltyRefreshIdentityProvider: PenaltyRefreshIdentityProviding {
    func currentIdentity() -> PenaltyRefreshIdentitySnapshot {
        PenaltyRefreshIdentitySnapshot(
            clerkUserID: Clerk.shared.user?.id,
            revenueCatAppUserID: Purchases.shared.appUserID,
            isRevenueCatAnonymous: Purchases.shared.isAnonymous
        )
    }
}
