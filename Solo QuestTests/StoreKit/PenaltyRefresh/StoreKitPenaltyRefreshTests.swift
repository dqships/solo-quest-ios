//
//  StoreKitPenaltyRefreshTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import XCTest
@testable import Solo_Quest

@MainActor
final class StoreKitPenaltyRefreshTests: XCTestCase {
    func testSignedInRefreshBecomesStaleAfterSignOut() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let service = makeService(identityProvider: identityProvider, fetcher: fetcher)

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        identityProvider.identity = anonymousIdentity("$RCAnonymousID:after-signout")
        fetcher.succeed(proPayload, at: 0)

        let result = await refresh.value
        XCTAssertEqual(result, .unresolved)
        XCTAssertEqual(service.penaltyEntitlementDecision, .unresolved)
        XCTAssertFalse(service.isPro)
    }

    func testSignedInRefreshBecomesStaleAfterClerkAccountSwitch() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let service = makeService(identityProvider: identityProvider, fetcher: fetcher)

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        identityProvider.identity = linkedIdentity("clerk:beta")
        fetcher.succeed(proPayload, at: 0)

        let result = await refresh.value
        XCTAssertEqual(result, .unresolved)
        XCTAssertEqual(service.penaltyEntitlementDecision, .unresolved)
        XCTAssertFalse(service.isPro)
    }

    func testAnonymousRefreshBecomesStaleAfterRevenueCatAnonymousIDRotation() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: anonymousIdentity("$RCAnonymousID:first"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let service = makeService(identityProvider: identityProvider, fetcher: fetcher)

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        identityProvider.identity = anonymousIdentity("$RCAnonymousID:rotated")
        fetcher.succeed(proPayload, at: 0)

        let result = await refresh.value
        XCTAssertEqual(result, .unresolved)
        XCTAssertEqual(service.penaltyEntitlementDecision, .unresolved)
        XCTAssertFalse(service.isPro)
    }

    func testLatestOverlappingRefreshWinsWhenResponsesCompleteInReverseOrder() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let service = makeService(identityProvider: identityProvider, fetcher: fetcher)

        let firstRefresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        let secondRefresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 2)
        fetcher.succeed(freePayload, at: 1)

        let secondResult = await secondRefresh.value
        XCTAssertEqual(secondResult, .freeVerified)
        fetcher.succeed(proPayload, at: 0)

        let firstResult = await firstRefresh.value
        XCTAssertEqual(firstResult, .unresolved)
        XCTAssertEqual(service.penaltyEntitlementDecision, .freeVerified)
        XCTAssertFalse(service.isPro)
    }

    func testLinkedOwnerUsesExactCachedProSnapshotAfterRefreshFailure() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let store = makeEntitlementStore()
        store.save(clerkUserId: "clerk:alpha", expirationDate: Date().addingTimeInterval(3_600))
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: fetcher,
            entitlementStore: store
        )

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        fetcher.fail(at: 0)

        let result = await refresh.value
        XCTAssertEqual(result, .pro)
        XCTAssertEqual(service.penaltyEntitlementDecision, .pro)
        XCTAssertFalse(service.isPro)
    }

    func testDifferentLinkedOwnerCannotUseAnotherOwnersCachedProSnapshot() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:beta"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let store = makeEntitlementStore()
        store.save(clerkUserId: "clerk:alpha", expirationDate: Date().addingTimeInterval(3_600))
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: fetcher,
            entitlementStore: store
        )

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        fetcher.fail(at: 0)

        let result = await refresh.value
        XCTAssertEqual(result, .unresolved)
        XCTAssertNotNil(store.activeSnapshot(for: "clerk:alpha"))
    }

    func testMatchingBoundAnonymousIdentityUsesCachedProSnapshotAfterFreeRefresh() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: anonymousIdentity("$RCAnonymousID:one"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let store = makeEntitlementStore()
        store.save(clerkUserId: "clerk:alpha", expirationDate: Date().addingTimeInterval(3_600))
        store.bindActiveSnapshot(
            for: "clerk:alpha",
            toAnonymousRevenueCatAppUserID: "$RCAnonymousID:one"
        )
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: fetcher,
            entitlementStore: store
        )

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        fetcher.succeed(freePayload, at: 0)

        let result = await refresh.value
        XCTAssertEqual(result, .pro)
        XCTAssertEqual(service.penaltyEntitlementDecision, .pro)
        XCTAssertFalse(service.isPro)
    }

    func testDifferentAnonymousIdentityCannotInheritPriorOwnersBoundProSnapshot() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:beta"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let store = makeEntitlementStore()
        store.save(clerkUserId: "clerk:alpha", expirationDate: Date().addingTimeInterval(3_600))
        store.bindActiveSnapshot(
            for: "clerk:alpha",
            toAnonymousRevenueCatAppUserID: "$RCAnonymousID:alpha"
        )
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: fetcher,
            entitlementStore: store
        )

        let betaRefresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        fetcher.succeed(freePayload, at: 0)

        let betaResult = await betaRefresh.value
        XCTAssertEqual(betaResult, .freeVerified)

        identityProvider.identity = anonymousIdentity("$RCAnonymousID:beta")
        let signedOutRefresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        fetcher.fail(at: 0)

        let signedOutResult = await signedOutRefresh.value
        XCTAssertEqual(signedOutResult, .unresolved)
        XCTAssertNotNil(store.activeSnapshot(for: "clerk:alpha"))
    }

    func testUnboundLegacySnapshotDoesNotProtectAnonymousRefresh() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: anonymousIdentity("$RCAnonymousID:legacy"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let store = makeEntitlementStore()
        store.save(clerkUserId: "clerk:alpha", expirationDate: Date().addingTimeInterval(3_600))
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: fetcher,
            entitlementStore: store
        )

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        fetcher.fail(at: 0)

        let result = await refresh.value
        XCTAssertEqual(result, .unresolved)
        XCTAssertEqual(service.penaltyEntitlementDecision, .unresolved)
    }

    func testRefreshFailureFallbackRequiresCurrentBoundAnonymousIdentity() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: anonymousIdentity("$RCAnonymousID:other"))
        let store = makeEntitlementStore()
        store.save(clerkUserId: "clerk:alpha", expirationDate: Date().addingTimeInterval(3_600))
        store.bindActiveSnapshot(
            for: "clerk:alpha",
            toAnonymousRevenueCatAppUserID: "$RCAnonymousID:alpha"
        )
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: PenaltyRefreshTestCustomerInfoFetcher(),
            entitlementStore: store
        )

        let decision = await Task { @MainActor in
            service.updatePenaltyEntitlementAfterRefreshFailure()
        }.value

        XCTAssertEqual(decision, .unresolved)
        XCTAssertEqual(service.penaltyEntitlementDecision, .unresolved)
    }

    func testRetainedPaywallRequestDoesNotApplyAfterAccountSwitch() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: PenaltyRefreshTestCustomerInfoFetcher()
        )

        guard let token = service.captureExternalCustomerInfoToken() else {
            return XCTFail("Expected a coherent linked customer-info token.")
        }
        identityProvider.identity = linkedIdentity("clerk:beta")
        let payload = proPayload
        let applied = await Task { @MainActor in
            service.applyExternalCustomerInfoPayload(payload, token: token)
        }.value

        XCTAssertFalse(applied)
        XCTAssertEqual(service.penaltyEntitlementDecision, .unresolved)
        XCTAssertFalse(service.isPro)
    }

    func testCurrentExternalCustomerInfoAppliesWithCapturedRequest() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: PenaltyRefreshTestCustomerInfoFetcher()
        )

        guard let token = service.captureExternalCustomerInfoToken() else {
            return XCTFail("Expected a coherent linked customer-info token.")
        }
        let payload = proPayload
        let applied = await Task { @MainActor in
            service.applyExternalCustomerInfoPayload(payload, token: token)
        }.value

        XCTAssertTrue(applied)
        XCTAssertEqual(service.penaltyEntitlementDecision, .pro)
        XCTAssertTrue(service.isPro)
    }

    func testRetainedPaywallTokenSurvivesSameIdentityPenaltyRefresh() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let service = makeService(identityProvider: identityProvider, fetcher: fetcher)
        guard let token = service.captureExternalCustomerInfoToken() else {
            return XCTFail("Expected a coherent linked customer-info token.")
        }

        let refresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        fetcher.succeed(freePayload, at: 0)
        _ = await refresh.value

        let applied = await Task { @MainActor in
            service.applyExternalCustomerInfoPayload(proPayload, token: token)
        }.value

        XCTAssertTrue(applied)
        XCTAssertTrue(service.isPro)
    }

    func testRetainedPaywallTokenFailsAfterSignOutIdentityEpochInvalidates() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let service = makeService(
            identityProvider: identityProvider,
            fetcher: PenaltyRefreshTestCustomerInfoFetcher()
        )
        guard let token = service.captureExternalCustomerInfoToken() else {
            return XCTFail("Expected a coherent linked customer-info token.")
        }

        identityProvider.identity = anonymousIdentity("$RCAnonymousID:after-signout")
        service.invalidateExternalCustomerInfoTokens()
        let applied = await Task { @MainActor in
            service.applyExternalCustomerInfoPayload(proPayload, token: token)
        }.value

        XCTAssertFalse(applied)
        XCTAssertFalse(service.isPro)
    }

    func testStaleFailureDoesNotOverwriteNewerRefreshResult() async {
        let identityProvider = PenaltyRefreshTestIdentityProvider(identity: linkedIdentity("clerk:alpha"))
        let fetcher = PenaltyRefreshTestCustomerInfoFetcher()
        let service = makeService(identityProvider: identityProvider, fetcher: fetcher)

        let staleRefresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 1)
        let currentRefresh = Task { await service.refreshCustomerInfoForPenalty() }
        await waitForPendingRequest(in: fetcher, count: 2)
        fetcher.succeed(proPayload, at: 1)

        let currentResult = await currentRefresh.value
        XCTAssertEqual(currentResult, .pro)
        fetcher.fail(at: 0)

        let staleResult = await staleRefresh.value
        XCTAssertEqual(staleResult, .unresolved)
        XCTAssertEqual(service.penaltyEntitlementDecision, .pro)
        XCTAssertTrue(service.isPro)
    }

    private var proPayload: PenaltyCustomerInfoPayload {
        PenaltyCustomerInfoPayload(customerInfo: nil, isPro: true, proExpirationDate: Date().addingTimeInterval(3_600))
    }

    private var freePayload: PenaltyCustomerInfoPayload {
        PenaltyCustomerInfoPayload(customerInfo: nil, isPro: false, proExpirationDate: nil)
    }

    private func linkedIdentity(_ clerkUserID: String) -> PenaltyRefreshIdentitySnapshot {
        PenaltyRefreshIdentitySnapshot(
            clerkUserID: clerkUserID,
            revenueCatAppUserID: clerkUserID,
            isRevenueCatAnonymous: false
        )
    }

    private func anonymousIdentity(_ revenueCatAppUserID: String) -> PenaltyRefreshIdentitySnapshot {
        PenaltyRefreshIdentitySnapshot(
            clerkUserID: nil,
            revenueCatAppUserID: revenueCatAppUserID,
            isRevenueCatAnonymous: true
        )
    }

    private func makeEntitlementStore() -> LastKnownProEntitlementStore {
        let suiteName = "StoreKitPenaltyRefreshTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.removePersistentDomain(forName: suiteName)
        return LastKnownProEntitlementStore(defaults: defaults)
    }

    private func makeService(
        identityProvider: PenaltyRefreshTestIdentityProvider,
        fetcher: PenaltyRefreshTestCustomerInfoFetcher,
        entitlementStore: LastKnownProEntitlementStore? = nil
    ) -> StoreKitService {
        StoreKitService(
            skipRevenueCat: true,
            penaltyIdentityProvider: identityProvider,
            penaltyCustomerInfoFetcher: fetcher,
            lastKnownProEntitlementStore: entitlementStore ?? makeEntitlementStore()
        )
    }

    private func waitForPendingRequest(
        in fetcher: PenaltyRefreshTestCustomerInfoFetcher,
        count: Int
    ) async {
        for _ in 0 ..< 100 {
            if fetcher.pendingRequestCount >= count {
                return
            }
            await Task.yield()
        }
        XCTFail("Timed out waiting for \(count) pending customer-info request(s).")
    }
}
