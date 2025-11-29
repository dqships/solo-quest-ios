//
//  IsCurrentExternalCustomerInfoToken.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func isCurrentExternalCustomerInfoToken(
    _ token: ExternalCustomerInfoToken,
    currentIdentityEpoch: Int,
    currentIdentity: PenaltyRefreshIdentitySnapshot
) -> Bool {
    guard token.identityEpoch == currentIdentityEpoch,
          let expectation = PenaltyRefreshExpectation(snapshot: currentIdentity) else {
        return false
    }
    return token.expectation == expectation
}
