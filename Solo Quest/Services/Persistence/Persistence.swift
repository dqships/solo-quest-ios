//
//  Persistence.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//  Modified by DaQuan Louden on 11-03-2026
//

import CoreData

struct PersistenceController {
    /// iCloud sync is on only when a CloudKit container is configured; otherwise data stays on the device.
    private static var cloudKitContainerIdentifier: String? {
        ConfiguredInfoValue.string(forKey: "CloudKitContainerIdentifier")
    }

    static let shared = PersistenceController(inMemory: AppRuntimeMode.isRunningXCTest)

    #if DEBUG
    static let appStoreScreenshots = PersistenceController(inMemory: true)
    #endif

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Setup preview data if needed, but for now we leave it empty
        // as we have a separate JSON preview mechanism.
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    let readiness = CloudKitSyncReadiness()
    let storeLoadReadiness = StoreLoadReadiness()
    let hadPreexistingStoreAtLaunch: Bool

    func waitForStoreLoad() async throws { try await storeLoadReadiness.wait() }

    var isReadyForDailyReset: Bool {
        container is NSPersistentCloudKitContainer ? readiness.isReadyForDailyReset : readiness.didLoadStore
    }

    init(inMemory: Bool = false) {
        let cloudKitContainerIdentifier = inMemory ? nil : Self.cloudKitContainerIdentifier
        container = cloudKitContainerIdentifier == nil
            ? NSPersistentContainer(name: "Solo_Quest")
            : NSPersistentCloudKitContainer(name: "Solo_Quest")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        hadPreexistingStoreAtLaunch = !inMemory && (container.persistentStoreDescriptions.first.map {
            PersistenceStorePreexistenceDetector.hasPreexistingStore(description: $0, modelName: "Solo_Quest")
        } ?? false)

        container.persistentStoreDescriptions.forEach { description in
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true

            guard let cloudKitContainerIdentifier else { return }

            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: cloudKitContainerIdentifier
            )
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(
                true as NSNumber,
                forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
            )
        }

        if cloudKitContainerIdentifier != nil {
            observeCloudKitImportEvents()
        }
        let persistentContainer = container
        let readiness = readiness
        let storeLoadReadiness = storeLoadReadiness
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                readiness.recordLoadError(error)
                storeLoadReadiness.finish(.failure(error))
                print("❌ PersistenceController: Persistent store failed to load: \(error.localizedDescription)")
                return
            }

            readiness.markStoreLoaded()
            storeLoadReadiness.finish(.success(()))

            #if DEBUG
            PersistenceController.initializeCloudKitDevelopmentSchemaIfRequested(
                for: persistentContainer,
                inMemory: inMemory
            )
            #endif
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if inMemory {
            readiness.markInitialImportFinished()
        }
    }

}
