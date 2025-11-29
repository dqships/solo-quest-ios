//
//  AdventureAlbumManager+Album.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import Photos

extension AdventureAlbumManager {
    func fetchAdventureAlbum(completion: @escaping (PHAssetCollection?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumTitle)
        let collection = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: fetchOptions
        )

        if let existing = collection.firstObject {
            completion(existing)
            return
        }

        var placeholder: PHObjectPlaceholder?

        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumTitle)
            placeholder = request.placeholderForCreatedAssetCollection
        }) { success, error in
            if success, let placeholder = placeholder {
                let result = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                completion(result.firstObject)
            } else {
                print("Error creating album: \(String(describing: error))")
                completion(nil)
            }
        }
    }
}
