//
//  PenaltyRefreshExpectation.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

enum PenaltyRefreshExpectation: Equatable {
    case linked(clerkUserID: String)
    case anonymous(revenueCatAppUserID: String)

    init?(snapshot: PenaltyRefreshIdentitySnapshot) {
        if let clerkUserID = snapshot.clerkUserID {
            guard snapshot.revenueCatAppUserID == clerkUserID, !snapshot.isRevenueCatAnonymous else {
                return nil
            }
            self = .linked(clerkUserID: clerkUserID)
            return
        }

        guard snapshot.isRevenueCatAnonymous else { return nil }
        self = .anonymous(revenueCatAppUserID: snapshot.revenueCatAppUserID)
    }
}
