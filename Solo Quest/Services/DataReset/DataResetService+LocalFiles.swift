//
//  DataResetService+LocalFiles.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Foundation

extension DataResetService {
    func clearLocalAdventureLogFiles(itemIDs: [UUID]) throws {
        let folderURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("AdventureLog")

        for itemID in itemIDs {
            let fileURL = folderURL.appendingPathComponent("\(itemID.uuidString).jpg")
            guard FileManager.default.fileExists(atPath: fileURL.path) else { continue }
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}
