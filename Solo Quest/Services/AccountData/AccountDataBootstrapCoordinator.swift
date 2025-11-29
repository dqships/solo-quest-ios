//
//  AccountDataBootstrapCoordinator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Combine
import CoreData
import Foundation

@MainActor
final class AccountDataBootstrapCoordinator: ObservableObject {
    @Published private(set) var state: AccountDataBootstrapState = .preparing

    private let persistence: PersistenceController
    private let accountScopeProvider: AccountScopeProvider
    private let eligibilityStore: LegacyUpgradeEligibilityStore
    private var revision = 0
    private var currentIntent: AccountDataAuthIntent?
    private var bootstrapTask: Task<Void, Never>?
    private var cloudImportObserver: NSObjectProtocol?

    init(
        persistence: PersistenceController,
        accountScopeProvider: AccountScopeProvider,
        eligibilityStore: LegacyUpgradeEligibilityStore
    ) {
        self.persistence = persistence
        self.accountScopeProvider = accountScopeProvider
        self.eligibilityStore = eligibilityStore
        observeCloudKitImports()
    }

    var isLocallyReady: Bool {
        state.isLocallyReady
    }

    var errorMessage: String? {
        state.errorMessage
    }

    var canRetry: Bool {
        state.canRetry
    }

    func requestResolvedAuth(clerkUserID: String?) {
        let intent = AccountDataAuthIntent(clerkUserID: clerkUserID)
        let hasAlreadyRequestedIntent = intent == currentIntent && revision > 0
        guard !hasAlreadyRequestedIntent else {
            return
        }

        currentIntent = intent
        revision += 1
        bootstrapTask?.cancel()
        state = .preparing

        let currentRevision = revision
        bootstrapTask = Task { [weak self] in
            await self?.bootstrap(intent: intent, revision: currentRevision)
        }
    }

    func retryCurrentAuth() {
        guard let currentIntent else { return }

        revision += 1
        bootstrapTask?.cancel()
        state = .preparing

        let currentRevision = revision
        bootstrapTask = Task { [weak self] in
            await self?.bootstrap(intent: currentIntent, revision: currentRevision)
        }
    }

    private func bootstrap(intent: AccountDataAuthIntent, revision: Int) async {
        do {
            try await persistence.waitForStoreLoad()
            guard isCurrent(intent: intent, revision: revision) else { return }

            eligibilityStore.captureEligibility(persistence.hadPreexistingStoreAtLaunch)
            guard isCurrent(intent: intent, revision: revision) else { return }

            let scope = try reconcile(intent: intent)
            guard isCurrent(intent: intent, revision: revision) else { return }

            accountScopeProvider.activateResolvedScope(
                scope,
                persistWriteOwner: true
            )
            state = stateAfterReconciliation()
            if persistence.readiness.didFinishInitialImport {
                AccountDataReconciliationNotification.post(scope: scope)
            }
            bootstrapTask = nil
        } catch is CancellationError {
            return
        } catch {
            guard isCurrent(intent: intent, revision: revision) else { return }
            state = .failed(message: AccountDataBootstrapRecoveryMessage.value)
            bootstrapTask = nil
            print("⚠️ Account data bootstrap failed: \(error.localizedDescription)")
        }
    }

    private func reconcile(intent: AccountDataAuthIntent) throws -> AccountScope {
        let context = persistence.container.viewContext
        let writeOwnerID = resolvedWriteOwnerID(for: intent)

        try LegacyDatasetNormalizer.normalize(context: context)
        if writeOwnerID.hasPrefix("clerk:") {
            _ = try LegacyClaimAttemptRecorder.record(
                context: context,
                claimantOwnerID: writeOwnerID,
                eligibilityStore: eligibilityStore
            )
        }

        let resolution = try fetchLegacyClaimResolution(context: context)
        let scope = resolvedScope(
            writeOwnerID: writeOwnerID,
            intent: intent,
            resolution: resolution
        )
        let profile = try ensureAccountProfile(ownerID: writeOwnerID, context: context)
        profile.legacyClaimState = legacyClaimState(for: resolution, writeOwnerID: writeOwnerID)
        try AccountProfileCanonicalizer.canonicalize(
            context: context,
            ownerIDs: scope.readOwnerIDs
        )
        try UserStatsDuplicateReconciler.reconcile(
            context: context,
            ownerIDs: scope.readOwnerIDs
        )

        if context.hasChanges {
            try context.save()
        }

        return scope
    }

    private func resolvedWriteOwnerID(for intent: AccountDataAuthIntent) -> String {
        guard let clerkUserID = intent.clerkUserID else {
            return accountScopeProvider.activeScope.writeOwnerID
        }
        return AccountOwnerIDFactory.clerk(clerkUserID)
    }

    private func fetchLegacyClaimResolution(context: NSManagedObjectContext) throws -> LegacyClaimResolution {
        let request: NSFetchRequest<LegacyDatasetClaim> = LegacyDatasetClaim.fetchRequest()
        request.predicate = NSPredicate(format: "datasetID == %@", LegacyClaimDatasetID.value)
        return resolveLegacyClaims(try context.fetch(request))
    }

    private func legacyClaimState(
        for resolution: LegacyClaimResolution,
        writeOwnerID: String
    ) -> String {
        switch resolution {
        case .conflict:
            return "conflict"
        case let .claimed(ownerID) where ownerID == writeOwnerID:
            return "claimed"
        case .claimed, .unclaimed:
            return "unclaimed"
        }
    }

    private func resolvedScope(
        writeOwnerID: String,
        intent: AccountDataAuthIntent,
        resolution: LegacyClaimResolution
    ) -> AccountScope {
        var readOwnerIDs: Set<String> = [writeOwnerID]
        if canReadQuarantinedLegacyData(
            writeOwnerID: writeOwnerID,
            intent: intent,
            resolution: resolution
        ) {
            readOwnerIDs.insert(AccountOwnerIDFactory.legacy)
        }
        return AccountScope(writeOwnerID: writeOwnerID, readOwnerIDs: readOwnerIDs)
    }

    private func canReadQuarantinedLegacyData(
        writeOwnerID: String,
        intent: AccountDataAuthIntent,
        resolution: LegacyClaimResolution
    ) -> Bool {
        switch resolution {
        case let .claimed(ownerID):
            return ownerID == writeOwnerID
        case .conflict:
            return false
        case .unclaimed:
            return eligibilityStore.isEligible == true &&
                intent.clerkUserID == nil &&
                writeOwnerID.hasPrefix("local:")
        }
    }

    private func stateAfterReconciliation() -> AccountDataBootstrapState {
        let context = persistence.container.viewContext
        let resolution = (try? fetchLegacyClaimResolution(context: context)) ?? .unclaimed
        if resolution == .conflict {
            return .legacyClaimConflict
        }

        guard persistence.container is NSPersistentCloudKitContainer else {
            return .readyLocal(cloudPending: false)
        }
        return persistence.readiness.didFinishInitialImport ? .readySynced : .readyLocal(cloudPending: true)
    }

    private func isCurrent(intent: AccountDataAuthIntent, revision: Int) -> Bool {
        currentIntent == intent && self.revision == revision && !Task.isCancelled
    }

    private func observeCloudKitImports() {
        guard let cloudContainer = persistence.container as? NSPersistentCloudKitContainer else { return }

        cloudImportObserver = NotificationCenter.default.addObserver(
            forName: NSPersistentCloudKitContainer.eventChangedNotification,
            object: cloudContainer,
            queue: .main
        ) { [weak self] notification in
            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                as? NSPersistentCloudKitContainer.Event,
                event.type == .import,
                event.endDate != nil,
                event.succeeded else {
                return
            }

            Task { @MainActor [weak self] in
                self?.reconcileAfterSuccessfulCloudImport()
            }
        }
    }

    private func reconcileAfterSuccessfulCloudImport() {
        guard let currentIntent else { return }

        let currentRevision = revision
        Task { [weak self] in
            guard let self else { return }
            guard self.isCurrent(intent: currentIntent, revision: currentRevision) else { return }

            do {
                let scope = try self.reconcile(intent: currentIntent)
                guard self.isCurrent(intent: currentIntent, revision: currentRevision) else { return }

                self.accountScopeProvider.activateResolvedScope(
                    scope,
                    persistWriteOwner: true
                )
                self.state = self.stateAfterReconciliation()
                AccountDataReconciliationNotification.post(scope: scope)
            } catch {
                print("⚠️ Account data import reconciliation failed: \(error.localizedDescription)")
            }
        }
    }
}
