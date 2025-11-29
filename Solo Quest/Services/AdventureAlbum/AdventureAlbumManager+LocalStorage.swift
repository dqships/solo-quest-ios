//
//  AdventureAlbumManager+LocalStorage.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import UIKit

extension AdventureAlbumManager {
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func getLocalImageURL(for itemID: UUID) -> URL {
        getDocumentsDirectory().appendingPathComponent("AdventureLog").appendingPathComponent("\(itemID.uuidString).jpg")
    }

    func saveImageLocally(_ image: UIImage, id: UUID) {
        let folder = getDocumentsDirectory().appendingPathComponent("AdventureLog")
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }

        let fileURL = folder.appendingPathComponent("\(id.uuidString).jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: fileURL)
        }
    }
}
