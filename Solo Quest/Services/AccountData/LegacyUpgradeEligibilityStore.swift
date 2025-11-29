//
//  LegacyUpgradeEligibilityStore.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CryptoKit
import Foundation

final class LegacyUpgradeEligibilityStore {
    private let defaults: UserDefaults
    private let scopeStore: ActiveAccountScopeStore
    private let eligibilityKey = "legacyUpgrade.preV2Eligible"
    private let attemptedOwnerKey = "legacyUpgrade.attemptedClerkOwner"

    init(defaults: UserDefaults = .standard, scopeStore: ActiveAccountScopeStore = ActiveAccountScopeStore()) {
        self.defaults = defaults
        self.scopeStore = scopeStore
    }

    func captureEligibility(_ isEligible: Bool) {
        guard defaults.object(forKey: eligibilityKey) == nil else { return }
        defaults.set(isEligible, forKey: eligibilityKey)
    }

    var isEligible: Bool? {
        guard defaults.object(forKey: eligibilityKey) != nil else { return nil }
        return defaults.bool(forKey: eligibilityKey)
    }

    func recordAttemptedClerkOwner(_ ownerID: String) -> Bool {
        guard let existing = defaults.string(forKey: attemptedOwnerKey) else {
            defaults.set(ownerID, forKey: attemptedOwnerKey)
            return true
        }
        return existing == ownerID
    }

    var attemptedClerkOwnerID: String? { defaults.string(forKey: attemptedOwnerKey) }
    var installationID: UUID { scopeStore.installationID() }
    var installationIDHash: String { SHA256.hash(data: Data(installationID.uuidString.utf8)).map { String(format: "%02x", $0) }.joined() }
}
