//
//  AnalyticsIdentityService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//  Modified by DaQuan Louden on 08-25-2026
//

import Clerk
import Factory
import Foundation
import RevenueCat

@MainActor
final class AnalyticsIdentityService {
    @Injected(\.analyticsManager) private var analytics
    @Injected(\.storeKitService) private var storeKit

    private var identityRevision = 0
    private var hasScheduledRepair = false
    private var hasPerformedRepairForCurrentIntent = false
    private var lastRequestedClerkUserID: String?
    private var hasRequestedIdentity = false

    func syncCurrentUser() async {
        await sync(user: Clerk.shared.user)
    }

    func sync(user: User?) async {
        hasPerformedRepairForCurrentIntent = false
        await synchronize(user: user)
    }

    private func synchronize(user: User?) async {
        storeKit.invalidatePenaltyRefreshes()
        invalidateExternalCustomerInfoTokensIfIdentityChanged(to: user?.id)
        let revision = nextIdentityRevision()

        guard let user else {
            await unlink(revision: revision)
            return
        }

        let profile = ClerkUserAnalyticsProfileFactory.make(from: user)
        do {
            let revenueCatResult = try await revenueCatCustomerInfo(for: profile.clerkUserId)
            guard isCurrentAnalyticsIdentityResult(
                expectation: .linked(clerkUserID: profile.clerkUserId),
                capturedRevision: revision,
                currentRevision: identityRevision,
                currentClerkUserID: Clerk.shared.user?.id,
                revenueCatAppUserID: Purchases.shared.appUserID,
                isRevenueCatAnonymous: Purchases.shared.isAnonymous
            ) else {
                scheduleRepairForCurrentClerkUser()
                return
            }

            applyLinkedIdentity(
                profile: profile,
                customerInfo: revenueCatResult.customerInfo,
                created: revenueCatResult.created
            )
        } catch {
            guard isCurrentAnalyticsIdentityResult(
                expectation: .linked(clerkUserID: profile.clerkUserId),
                capturedRevision: revision,
                currentRevision: identityRevision,
                currentClerkUserID: Clerk.shared.user?.id,
                revenueCatAppUserID: Purchases.shared.appUserID,
                isRevenueCatAnonymous: Purchases.shared.isAnonymous
            ) else {
                scheduleRepairForCurrentClerkUser()
                return
            }

            AnalyticsIdentityStorage.linkedClerkUserId = profile.clerkUserId
            analytics.identify(userId: profile.clerkUserId, userProperties: profile.postHogUserProperties)
            analytics.track(event: "identity_link_failed", properties: [
                "clerk_user_id": profile.clerkUserId,
                "provider": "revenuecat",
                "error_description": error.localizedDescription
            ])
        }
    }

    func clearLinkedIdentityIfNeeded() async {
        hasPerformedRepairForCurrentIntent = false
        storeKit.invalidatePenaltyRefreshes()
        storeKit.invalidateExternalCustomerInfoTokens()
        let revision = nextIdentityRevision()
        await unlink(revision: revision)
    }

    private func unlink(revision: Int) async {
        let linkedClerkUserID = AnalyticsIdentityStorage.linkedClerkUserId
        var completedRevenueCatLogout = false
        if !Purchases.shared.isAnonymous {
            do {
                _ = try await Purchases.shared.logOut()
                completedRevenueCatLogout = true
            } catch {
                guard isCurrentAnalyticsIdentityResult(
                    expectation: .unlinked,
                    capturedRevision: revision,
                    currentRevision: identityRevision,
                    currentClerkUserID: Clerk.shared.user?.id,
                    revenueCatAppUserID: Purchases.shared.appUserID,
                    isRevenueCatAnonymous: Purchases.shared.isAnonymous
                ) else {
                    scheduleRepairForCurrentClerkUser()
                    return
                }
            }
        }

        guard isCurrentAnalyticsIdentityResult(
            expectation: .unlinked,
            capturedRevision: revision,
            currentRevision: identityRevision,
            currentClerkUserID: Clerk.shared.user?.id,
            revenueCatAppUserID: Purchases.shared.appUserID,
            isRevenueCatAnonymous: Purchases.shared.isAnonymous
        ) else {
            scheduleRepairForCurrentClerkUser()
            return
        }

        // Keep the last verified Pro expiry. Sign-out changes RevenueCat's app user,
        // but must not turn an active paid subscription into a penalty.
        if completedRevenueCatLogout, let linkedClerkUserID {
            storeKit.bindLastKnownProSnapshotToCurrentAnonymousRevenueCatIdentity(
                for: linkedClerkUserID
            )
        }
        _ = storeKit.updatePenaltyEntitlementAfterRefreshFailure()
        AnalyticsIdentityStorage.linkedClerkUserId = nil
        analytics.reset()
    }

    private func applyLinkedIdentity(
        profile: ClerkUserAnalyticsProfile,
        customerInfo: CustomerInfo,
        created: Bool
    ) {
        Purchases.shared.attribution.setEmail(profile.emailAddress)
        Purchases.shared.attribution.setDisplayName(profile.displayName)
        Purchases.shared.attribution.setPostHogUserID(profile.clerkUserId)
        Purchases.shared.attribution.setAttributes(profile.revenueCatAttributes)

        guard let token = storeKit.captureExternalCustomerInfoToken() else { return }
        guard storeKit.applyCustomerInfo(customerInfo, token: token) else { return }
        AnalyticsIdentityStorage.linkedClerkUserId = profile.clerkUserId

        var userProperties = profile.postHogUserProperties
        userProperties.merge(
            RevenueCatCustomerInfoAnalyticsProperties.make(from: customerInfo),
            uniquingKeysWith: { _, new in new }
        )

        analytics.identify(userId: profile.clerkUserId, userProperties: userProperties)
        analytics.track(event: "identity_linked", properties: [
            "clerk_user_id": profile.clerkUserId,
            "posthog_distinct_id": profile.clerkUserId,
            "revenuecat_app_user_id": Purchases.shared.appUserID,
            "revenuecat_created": created,
            "primary_auth_provider": profile.primaryAuthProvider,
            "email_domain": profile.emailDomain ?? "missing",
            "email_type": profile.emailType.rawValue
        ])
    }

    private func revenueCatCustomerInfo(
        for clerkUserId: String
    ) async throws -> (customerInfo: CustomerInfo, created: Bool) {
        if Purchases.shared.appUserID == clerkUserId, !Purchases.shared.isAnonymous {
            return (try await Purchases.shared.customerInfo(), false)
        }

        return try await Purchases.shared.logIn(clerkUserId)
    }

    private func nextIdentityRevision() -> Int {
        identityRevision += 1
        return identityRevision
    }

    private func invalidateExternalCustomerInfoTokensIfIdentityChanged(to clerkUserID: String?) {
        guard !hasRequestedIdentity || lastRequestedClerkUserID != clerkUserID else { return }
        hasRequestedIdentity = true
        lastRequestedClerkUserID = clerkUserID
        storeKit.invalidateExternalCustomerInfoTokens()
    }

    private func scheduleRepairForCurrentClerkUser() {
        guard !hasScheduledRepair, !hasPerformedRepairForCurrentIntent else { return }

        hasScheduledRepair = true
        hasPerformedRepairForCurrentIntent = true
        Task { @MainActor [weak self] in
            await Task.yield()
            guard let self else { return }
            self.hasScheduledRepair = false
            await self.synchronize(user: Clerk.shared.user)
        }
    }

}
