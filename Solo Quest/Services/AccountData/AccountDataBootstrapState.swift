//
//  AccountDataBootstrapState.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

enum AccountDataBootstrapState: Equatable {
    case preparing
    case readyLocal(cloudPending: Bool)
    case readySynced
    case legacyClaimConflict
    case failed(message: String)

    var isLocallyReady: Bool {
        switch self {
        case .readyLocal, .readySynced, .legacyClaimConflict:
            return true
        case .preparing, .failed:
            return false
        }
    }

    var errorMessage: String? {
        guard case let .failed(message) = self else { return nil }
        return message
    }

    var canRetry: Bool {
        if case .failed = self {
            return true
        }
        return false
    }
}
