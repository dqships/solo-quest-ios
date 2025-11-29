//
//  AccountScopeProvider.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//
import Combine
import Foundation

protocol AccountScopeProviding { var activeScope: AccountScope { get } }

@MainActor
final class AccountScopeProvider: ObservableObject, AccountScopeProviding {
    private let store = ActiveAccountScopeStore()
    @Published private(set) var activeScope: AccountScope

    init() {
        activeScope = AccountScope(ownerID: store.lastOwnerID() ?? store.localOwnerID())
    }

    func resolve(clerkUserID: String?) {
        let ownerID = clerkUserID.map(AccountOwnerIDFactory.clerk) ?? activeScope.ownerID
        store.retain(ownerID)
        activeScope = AccountScope(ownerID: ownerID)
    }

    func activateResolvedScope(_ scope: AccountScope, persistWriteOwner: Bool) {
        if persistWriteOwner {
            store.retain(scope.writeOwnerID)
        }
        activeScope = scope
    }

    func activateTransientScope(ownerID: String) {
        activeScope = AccountScope(ownerID: ownerID)
    }
}
