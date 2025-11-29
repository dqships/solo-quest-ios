//
//  PersistenceStorePreexistenceDetector.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Foundation

enum PersistenceStorePreexistenceDetector {
    static func hasPreexistingStore(description: NSPersistentStoreDescription, modelName: String) -> Bool {
        let storeURL = description.url ?? NSPersistentContainer.defaultDirectoryURL()
            .appendingPathComponent("\(modelName).sqlite")
        let paths = [
            storeURL,
            URL(fileURLWithPath: storeURL.path + "-wal"),
            URL(fileURLWithPath: storeURL.path + "-shm"),
            URL(fileURLWithPath: storeURL.path + "-journal")
        ]

        return paths.contains { FileManager.default.fileExists(atPath: $0.path) }
    }
}
