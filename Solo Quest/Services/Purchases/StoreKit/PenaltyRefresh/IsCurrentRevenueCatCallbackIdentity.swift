//
//  IsCurrentRevenueCatCallbackIdentity.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func isCurrentRevenueCatCallbackIdentity(
    _ capturedIdentity: RevenueCatCallbackIdentity,
    currentIdentity: PenaltyRefreshIdentitySnapshot
) -> Bool {
    capturedIdentity.revenueCatAppUserID == currentIdentity.revenueCatAppUserID
        && capturedIdentity.isRevenueCatAnonymous == currentIdentity.isRevenueCatAnonymous
}
