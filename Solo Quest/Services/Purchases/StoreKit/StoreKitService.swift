//
//  StoreKitService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 08-25-2026
//

import Combine
import Foundation
import RevenueCat

@MainActor
class StoreKitService: NSObject, ObservableObject {
    @Published var isPro: Bool = false
    @Published var customerInfo: CustomerInfo?
    @Published var penaltyEntitlementDecision: PenaltyEntitlementDecision = .unresolved
    let lastKnownProEntitlementStore: LastKnownProEntitlementStore
    let penaltyIdentityProvider: PenaltyRefreshIdentityProviding
    let penaltyCustomerInfoFetcher: PenaltyCustomerInfoFetching
    var penaltyRefreshGeneration = 0
    var externalCustomerInfoIdentityEpoch = 0

    init(
        skipRevenueCat: Bool = false,
        penaltyIdentityProvider: PenaltyRefreshIdentityProviding? = nil,
        penaltyCustomerInfoFetcher: PenaltyCustomerInfoFetching? = nil,
        lastKnownProEntitlementStore: LastKnownProEntitlementStore? = nil
    ) {
        self.penaltyIdentityProvider = penaltyIdentityProvider ?? LivePenaltyRefreshIdentityProvider()
        self.penaltyCustomerInfoFetcher = penaltyCustomerInfoFetcher ?? LivePenaltyCustomerInfoFetcher()
        self.lastKnownProEntitlementStore = lastKnownProEntitlementStore ?? LastKnownProEntitlementStore()
        super.init()

        guard !skipRevenueCat, !AppRuntimeMode.isRunningXCTest else { return }

        Purchases.shared.delegate = self
        refreshCustomerInfo()
    }

    func invalidatePenaltyRefreshes() {
        penaltyRefreshGeneration += 1
    }

    func invalidateExternalCustomerInfoTokens() {
        externalCustomerInfoIdentityEpoch += 1
    }

    func nextPenaltyRefreshRequest() -> PenaltyRefreshRequest? {
        penaltyRefreshGeneration += 1
        let identity = penaltyIdentityProvider.currentIdentity()
        guard let expectation = PenaltyRefreshExpectation(snapshot: identity) else {
            return nil
        }
        return PenaltyRefreshRequest(
            generation: penaltyRefreshGeneration,
            expectation: expectation
        )
    }

    func captureExternalCustomerInfoToken() -> ExternalCustomerInfoToken? {
        let identity = penaltyIdentityProvider.currentIdentity()
        guard let expectation = PenaltyRefreshExpectation(snapshot: identity) else {
            return nil
        }
        return ExternalCustomerInfoToken(
            identityEpoch: externalCustomerInfoIdentityEpoch,
            expectation: expectation
        )
    }

    func isCurrentPenaltyRefreshRequest(_ request: PenaltyRefreshRequest) -> Bool {
        isPenaltyRefreshRequestCurrent(
            request,
            currentGeneration: penaltyRefreshGeneration,
            currentIdentity: penaltyIdentityProvider.currentIdentity()
        )
    }

    func isCurrentExternalCustomerInfoToken(_ token: ExternalCustomerInfoToken) -> Bool {
        Solo_Quest.isCurrentExternalCustomerInfoToken(
            token,
            currentIdentityEpoch: externalCustomerInfoIdentityEpoch,
            currentIdentity: penaltyIdentityProvider.currentIdentity()
        )
    }
}
