//
//  PersistenceController+CloudKitSchemaInitialization.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

#if DEBUG
import CoreData
import Foundation

extension PersistenceController {
    private static let cloudKitSchemaInitializationArgument = "-InitializeCloudKitSchema"

    static func initializeCloudKitDevelopmentSchemaIfRequested(
        for container: NSPersistentContainer,
        inMemory: Bool
    ) {
        guard !inMemory else { return }
        guard ProcessInfo.processInfo.arguments.contains(cloudKitSchemaInitializationArgument) else {
            return
        }
        guard let cloudKitContainer = container as? NSPersistentCloudKitContainer else {
            fatalError("CloudKit schema initialization requires NSPersistentCloudKitContainer.")
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try cloudKitContainer.initializeCloudKitSchema(options: [])
                print("CloudKit development schema initialized.")
            } catch {
                fatalError("CloudKit development schema initialization failed: \(error)")
            }
        }
    }
}
#endif
