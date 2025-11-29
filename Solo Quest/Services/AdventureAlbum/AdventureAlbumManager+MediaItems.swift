//
//  AdventureAlbumManager+MediaItems.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Foundation
import Photos

extension AdventureAlbumManager {
    func createMediaItem(
        id: UUID,
        assetID: String,
        mediaType: String,
        quest: QuestInstance?,
        context: NSManagedObjectContext
    ) -> MediaItem? {
        let scope = accountScopeProvider.activeScope
        if let quest, !isOwnedByActiveAccount(quest, scope: scope) {
            print("⚠️ AdventureAlbumManager: Refused cross-account media creation")
            return nil
        }
        let item = MediaItem(context: context)
        item.ownerID = quest?.ownerID ?? scope.ownerID
        item.id = id
        item.assetID = assetID
        item.mediaType = mediaType
        item.createdAt = Date()
        item.caption = nil
        item.tag = nil
        item.isFavorite = false
        item.quest = quest

        analytics.trackMediaCaptured(type: mediaType, questId: quest?.id?.uuidString)

        return item
    }

    func fetchAllMediaItems(context: NSManagedObjectContext) -> [MediaItem] {
        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.predicate = accountOwnedPredicate(accountScopeProvider.activeScope)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching media items: \(error)")
            return []
        }
    }

    func fetchMediaItems(for quest: QuestInstance, context: NSManagedObjectContext) -> [MediaItem] {
        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.predicate = accountScopedPredicate(NSPredicate(format: "quest == %@", quest), scope: accountScopeProvider.activeScope)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching quest media: \(error)")
            return []
        }
    }

    func fetchAsset(for mediaItem: MediaItem) -> PHAsset? {
        guard let assetID = mediaItem.assetID else { return nil }
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        return result.firstObject
    }
}
