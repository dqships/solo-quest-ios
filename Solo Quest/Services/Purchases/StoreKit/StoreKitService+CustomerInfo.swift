//
//  StoreKitService+CustomerInfo.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 11-03-2026
//

import Foundation
import RevenueCat

extension StoreKitService {
    @discardableResult
    func refreshCustomerInfoForPenalty() async -> PenaltyEntitlementDecision {
        // Without a RevenueCat key there is nothing to verify, so the player is a free player.
        guard RevenueCatConfigurator.hasAPIKey || AppRuntimeMode.isRunningXCTest else {
            penaltyEntitlementDecision = .freeVerified
            return .freeVerified
        }

        guard let request = nextPenaltyRefreshRequest() else {
            return .unresolved
        }

        do {
            let payload = try await penaltyCustomerInfoFetcher.fetchCustomerInfo()
            guard isCurrentPenaltyRefreshRequest(request) else {
                return .unresolved
            }

            let decision = penaltyDecision(for: payload, expectation: request.expectation)
            applyPenaltyRefreshPayload(payload, decision: decision, request: request)
            return decision
        } catch {
            guard isCurrentPenaltyRefreshRequest(request) else {
                return .unresolved
            }

            let decision = cachedPenaltyDecision(for: request.expectation)
            penaltyEntitlementDecision = decision
            return decision
        }
    }

    func refreshCustomerInfo() {
        Task { [weak self] in
            _ = await self?.refreshCustomerInfoForPenalty()
        }
    }

    @discardableResult
    func applyCustomerInfo(
        _ info: CustomerInfo,
        token: ExternalCustomerInfoToken
    ) -> Bool {
        let entitlement = info.entitlements["pro"]
        let payload = PenaltyCustomerInfoPayload(
            customerInfo: info,
            isPro: entitlement?.isActive == true,
            proExpirationDate: entitlement?.expirationDate
        )
        let decision = penaltyDecision(for: payload, expectation: token.expectation)
        return applyExternalCustomerInfoPayload(
            payload,
            token: token,
            decision: decision
        )
    }

    func updatePenaltyEntitlementAfterRefreshFailure() -> PenaltyEntitlementDecision {
        guard let expectation = PenaltyRefreshExpectation(
            snapshot: penaltyIdentityProvider.currentIdentity()
        ) else {
            penaltyEntitlementDecision = .unresolved
            return .unresolved
        }
        let decision = cachedPenaltyDecision(for: expectation)
        penaltyEntitlementDecision = decision
        return decision
    }

    @discardableResult
    func applyDelegateCustomerInfo(
        _ customerInfo: CustomerInfo,
        capturedRevenueCatIdentity: RevenueCatCallbackIdentity
    ) -> Bool {
        guard isCurrentRevenueCatCallbackIdentity(
            capturedRevenueCatIdentity,
            currentIdentity: penaltyIdentityProvider.currentIdentity()
        ) else {
            return false
        }
        guard let token = captureExternalCustomerInfoToken() else {
            return false
        }
        return applyCustomerInfo(customerInfo, token: token)
    }

    private func penaltyDecision(
        for payload: PenaltyCustomerInfoPayload,
        expectation: PenaltyRefreshExpectation
    ) -> PenaltyEntitlementDecision {
        if payload.isPro {
            return .pro
        }
        if case let .anonymous(revenueCatAppUserID) = expectation,
           lastKnownProEntitlementStore.activeSnapshot(
               forAnonymousRevenueCatAppUserID: revenueCatAppUserID
           ) != nil {
            return .pro
        }
        return .freeVerified
    }

    private func cachedPenaltyDecision(
        for expectation: PenaltyRefreshExpectation
    ) -> PenaltyEntitlementDecision {
        switch expectation {
        case let .linked(clerkUserID):
            return lastKnownProEntitlementStore.activeSnapshot(for: clerkUserID) == nil
                ? .unresolved
                : .pro
        case let .anonymous(revenueCatAppUserID):
            return lastKnownProEntitlementStore.activeSnapshot(
                forAnonymousRevenueCatAppUserID: revenueCatAppUserID
            ) == nil
                ? .unresolved
                : .pro
        }
    }

    private func applyPenaltyRefreshPayload(
        _ payload: PenaltyCustomerInfoPayload,
        decision: PenaltyEntitlementDecision,
        request: PenaltyRefreshRequest
    ) {
        guard isCurrentPenaltyRefreshRequest(request) else { return }
        customerInfo = payload.customerInfo
        isPro = payload.isPro
        penaltyEntitlementDecision = decision

        if case let .linked(clerkUserID) = request.expectation {
            updateKnownProSnapshot(
                isPro: payload.isPro,
                expirationDate: payload.proExpirationDate,
                clerkUserID: clerkUserID
            )
        }
        if let customerInfo = payload.customerInfo {
            syncAnalyticsCustomerInfo(customerInfo)
        }
    }

    @discardableResult
    func applyExternalCustomerInfoPayload(
        _ payload: PenaltyCustomerInfoPayload,
        token: ExternalCustomerInfoToken,
        decision: PenaltyEntitlementDecision? = nil
    ) -> Bool {
        guard isCurrentExternalCustomerInfoToken(token) else { return false }
        customerInfo = payload.customerInfo
        isPro = payload.isPro
        penaltyEntitlementDecision = decision ?? (payload.isPro ? .pro : .freeVerified)
        if case let .linked(clerkUserID) = token.expectation {
            updateKnownProSnapshot(
                isPro: payload.isPro,
                expirationDate: payload.proExpirationDate,
                clerkUserID: clerkUserID
            )
        }
        if let customerInfo = payload.customerInfo {
            syncAnalyticsCustomerInfo(customerInfo)
        }
        return true
    }

    func bindLastKnownProSnapshotToCurrentAnonymousRevenueCatIdentity(
        for clerkUserID: String
    ) {
        let identity = penaltyIdentityProvider.currentIdentity()
        guard identity.clerkUserID == nil, identity.isRevenueCatAnonymous else { return }
        lastKnownProEntitlementStore.bindActiveSnapshot(
            for: clerkUserID,
            toAnonymousRevenueCatAppUserID: identity.revenueCatAppUserID
        )
    }

    private func updateKnownProSnapshot(
        isPro: Bool,
        expirationDate: Date?,
        clerkUserID: String
    ) {
        if isPro, let expirationDate {
            lastKnownProEntitlementStore.save(
                clerkUserId: clerkUserID,
                expirationDate: expirationDate
            )
        } else {
            lastKnownProEntitlementStore.clear(ifOwnedBy: clerkUserID)
        }
    }
}
