//
//  AdventureMediaDetailView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI
import AVKit
import Factory

struct AdventureMediaDetailView: View {
    let mediaItem: MediaItem
    @State private var player: AVPlayer?
    @StateObject private var loader: AssetImageLoader
    
    @Injected(\.analyticsManager) private var analytics
    @StateObject private var shareLoader: ShareImageLoader

    // Action Callbacks
    var onViewQuest: ((QuestInstance) -> Void)?

    init(mediaItem: MediaItem, onViewQuest: ((QuestInstance) -> Void)? = nil) {
        self.mediaItem = mediaItem
        self.onViewQuest = onViewQuest
        _loader = StateObject(
            wrappedValue: AssetImageLoader(
                mediaItem: mediaItem,
                targetSize: CGSize(width: 1600, height: 1600)
            )
        )
        _shareLoader = StateObject(wrappedValue: ShareImageLoader(mediaItem: mediaItem))
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AdventureMediaContentView(
                mediaItem: mediaItem,
                loader: loader,
                player: $player
            )
            
            AdventureMediaActionRail(
                mediaItem: mediaItem,
                shareImage: shareLoader.image,
                onViewQuest: onViewQuest,
                onShare: trackShare
            )
        }
        .onAppear {
            shareLoader.loadShareableImage()
            
            // Track View
            analytics.trackMediaViewed(
                id: mediaItem.id?.uuidString ?? "unknown",
                context: "feed"
            )
        }
    }

    private func trackShare() {
        analytics.trackMediaShared(id: mediaItem.id?.uuidString ?? "unknown")
    }
}
