//
//  AssetImageLoader.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI
import Photos
import UIKit
import Combine

final class AssetImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let imageManager = PHCachingImageManager()
    private let mediaItem: MediaItem
    private let targetSize: CGSize

    init(mediaItem: MediaItem, targetSize: CGSize) {
        self.mediaItem = mediaItem
        self.targetSize = targetSize
        load()
    }

    private func load() {
        // 1. Try loading from local documents (clean version)
        if let id = mediaItem.id {
            let localURL = AdventureAlbumManager.shared.getLocalImageURL(for: id)
            if let localImage = UIImage(contentsOfFile: localURL.path) {
                self.image = localImage
                return
            }
        }
        
        // 2. Fallback to Photo Library
        guard let assetID = mediaItem.assetID else { return }
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        guard let asset = assets.firstObject else { return }

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
