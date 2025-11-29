//
//  IsCurrentPenaltyRefreshRequest.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

func isPenaltyRefreshRequestCurrent(
    _ request: PenaltyRefreshRequest,
    currentGeneration: Int,
    currentIdentity: PenaltyRefreshIdentitySnapshot
) -> Bool {
    guard request.generation == currentGeneration else { return false }
    guard let currentExpectation = PenaltyRefreshExpectation(snapshot: currentIdentity) else {
        return false
    }
    return currentExpectation == request.expectation
}
