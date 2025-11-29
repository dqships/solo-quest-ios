//
//  LastKnownProEntitlementStore.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

final class LastKnownProEntitlementStore {
    private let key = "lastKnownProEntitlementSnapshot"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func activeSnapshot(for clerkUserId: String? = nil, at date: Date = Date()) -> LastKnownProEntitlementSnapshot? {
        guard let data = defaults.data(forKey: key),
              let snapshot = try? JSONDecoder().decode(LastKnownProEntitlementSnapshot.self, from: data) else {
            return nil
        }

        guard snapshot.isActive(at: date) else {
            defaults.removeObject(forKey: key)
            return nil
        }

        guard clerkUserId == nil || snapshot.clerkUserId == clerkUserId else {
            return nil
        }

        return snapshot
    }

    func save(clerkUserId: String, expirationDate: Date) {
        let snapshot = LastKnownProEntitlementSnapshot(clerkUserId: clerkUserId, expirationDate: expirationDate)
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: key)
    }

    func activeSnapshot(
        forAnonymousRevenueCatAppUserID anonymousRevenueCatAppUserID: String,
        at date: Date = Date()
    ) -> LastKnownProEntitlementSnapshot? {
        guard let snapshot = activeSnapshot(at: date),
              snapshot.anonymousRevenueCatAppUserID == anonymousRevenueCatAppUserID else {
            return nil
        }
        return snapshot
    }

    func bindActiveSnapshot(
        for clerkUserId: String,
        toAnonymousRevenueCatAppUserID anonymousRevenueCatAppUserID: String
    ) {
        guard let snapshot = activeSnapshot(for: clerkUserId) else { return }
        let boundSnapshot = LastKnownProEntitlementSnapshot(
            clerkUserId: snapshot.clerkUserId,
            expirationDate: snapshot.expirationDate,
            anonymousRevenueCatAppUserID: anonymousRevenueCatAppUserID
        )
        guard let data = try? JSONEncoder().encode(boundSnapshot) else { return }
        defaults.set(data, forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }

    func clear(ifOwnedBy clerkUserId: String) {
        guard let snapshot = activeSnapshot(), snapshot.clerkUserId == clerkUserId else {
            return
        }
        clear()
    }
}
