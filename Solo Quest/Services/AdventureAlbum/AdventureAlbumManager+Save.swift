//
//  AdventureAlbumManager+Save.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Factory
import Foundation
import Photos
import UIKit

extension AdventureAlbumManager {
    func saveImageToAdventureLog(
        _ image: UIImage,
        quest: QuestInstance?,
        context: NSManagedObjectContext,
        completion: @escaping (Bool) -> Void
    ) {
        let isPro = Container.shared.storeKitService().isPro
        let limit = isPro ? 10 : 3

        if let quest = quest {
            let currentCount = fetchMediaItems(for: quest, context: context).count
            if currentCount >= limit {
                print("Media limit reached for this quest.")
                completion(false)
                return
            }
        }

        let itemID = UUID()
        saveImageLocally(image, id: itemID)

        fetchAdventureAlbum { album in
            guard let album = album else {
                completion(false)
                return
            }

            var placeholder: PHObjectPlaceholder?

            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                placeholder = creationRequest.placeholderForCreatedAsset

                if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                   let placeholder = placeholder {
                    let assets = NSArray(object: placeholder)
                    albumChangeRequest.addAssets(assets)
                }
            }) { success, error in
                Task { @MainActor in
                    self.handleSaveCompletion(success: success, error: error, placeholder: placeholder, quest: quest, itemID: itemID, mediaType: "photo", context: context, completion: completion)
                }
            }
        }
    }

    func saveVideoToAdventureLog(
        _ videoURL: URL,
        quest: QuestInstance?,
        context: NSManagedObjectContext,
        completion: @escaping (Bool) -> Void
    ) {
        let isPro = Container.shared.storeKitService().isPro
        let limit = isPro ? 10 : 3

        if let quest = quest {
            let currentCount = fetchMediaItems(for: quest, context: context).count
            if currentCount >= limit {
                print("Media limit reached for this quest.")
                completion(false)
                return
            }
        }

        let itemID = UUID()

        fetchAdventureAlbum { album in
            guard let album = album else {
                completion(false)
                return
            }

            var placeholder: PHObjectPlaceholder?

            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                placeholder = creationRequest?.placeholderForCreatedAsset

                if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                   let placeholder = placeholder {
                    let assets = NSArray(object: placeholder)
                    albumChangeRequest.addAssets(assets)
                }
            }) { success, error in
                Task { @MainActor in
                    self.handleSaveCompletion(success: success, error: error, placeholder: placeholder, quest: quest, itemID: itemID, mediaType: "video", context: context, completion: completion)
                }
            }
        }
    }

    func handleSaveCompletion(
        success: Bool,
        error: Error?,
        placeholder: PHObjectPlaceholder?,
        quest: QuestInstance?,
        itemID: UUID,
        mediaType: String,
        context: NSManagedObjectContext,
        completion: @escaping (Bool) -> Void
    ) {
        if success, let assetID = placeholder?.localIdentifier {
                guard let item = self.createMediaItem(
                    id: itemID,
                    assetID: assetID,
                    mediaType: mediaType,
                    quest: quest,
                    context: context
                ) else {
                    completion(false)
                    return
                }

                do {
                    try context.save()
                    analytics.track(event: "adventure_log_item_created", properties: [
                        "media_type": mediaType,
                        "quest_id": item.quest?.id?.uuidString ?? "none",
                        "source": "adventure_log"
                    ])
                    completion(true)
                } catch {
                    print("Core Data save error: \(error)")
                    completion(false)
                }
        } else {
                if let error = error {
                    print("Media save error: \(error)")
                }
                completion(false)
        }
    }
}
