//
//  ShareImageLoader.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Combine
import Photos
import UIKit

class ShareImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let mediaItem: MediaItem
    
    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
    }
    
    func loadShareableImage() {
        if let id = mediaItem.id {
            let localURL = AdventureAlbumManager.shared.getLocalImageURL(for: id)
            if let localImage = UIImage(contentsOfFile: localURL.path) {
                image = localImage
                return
            }
        }
        
        guard let assetID = mediaItem.assetID else { return }
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        guard let asset = assets.firstObject else { return }
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        manager.requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .default,
            options: options
        ) { [weak self] result, _ in
            DispatchQueue.main.async {
                self?.image = result
            }
        }
    }
}
