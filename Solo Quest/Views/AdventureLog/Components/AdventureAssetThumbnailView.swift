//
//  AdventureAssetThumbnailView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI
import Photos

struct AdventureAssetThumbnailView: View {
    let mediaItem: MediaItem
    let size: CGFloat

    @StateObject private var loader: AssetImageLoader

    init(mediaItem: MediaItem, size: CGFloat = 110) {
        self.mediaItem = mediaItem
        self.size = size
        _loader = StateObject(
            wrappedValue: AssetImageLoader(
                mediaItem: mediaItem,
                targetSize: CGSize(width: size * 2, height: size * 2)
            )
        )
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.brandCardSurface
                    .overlay(ProgressView())
            }
        }
        .frame(width: size, height: size)
        .clipped()
        .cornerRadius(8)
        .overlay(
            Group {
                if mediaItem.mediaType == "video" {
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
            }
        )
    }
}
