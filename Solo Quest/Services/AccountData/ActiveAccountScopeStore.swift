//
//  ActiveAccountScopeStore.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//
import Foundation

final class ActiveAccountScopeStore {
    private let defaults = UserDefaults.standard
    private let installationKey = "account.installationID"
    private let lastOwnerKey = "account.lastOwnerID"
    func localOwnerID() -> String {
        AccountOwnerIDFactory.local(installationID())
    }

    func installationID() -> UUID {
        let installationID = UUID(uuidString: defaults.string(forKey: installationKey) ?? "") ?? UUID()
        defaults.set(installationID.uuidString, forKey: installationKey)
        return installationID
    }

    func retain(_ ownerID: String) { defaults.set(ownerID, forKey: lastOwnerKey) }
    func lastOwnerID() -> String? { defaults.string(forKey: lastOwnerKey) }
}
