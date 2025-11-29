//
//  AdventureMediaContentView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Photos
import AVKit

struct AdventureMediaContentView: View {
    let mediaItem: MediaItem
    @ObservedObject var loader: AssetImageLoader
    @Binding var player: AVPlayer?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if mediaItem.mediaType == "video" {
                if let player = player {
                    VideoPlayer(player: player)
                        .ignoresSafeArea()
                        .onAppear { player.play() }
                        .onDisappear { player.pause() }
                } else {
                    ProgressView().onAppear { loadVideo() }
                }
            } else {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                } else {
                    ProgressView()
                }
            }
        }
    }
    
    private func loadVideo() {
        // Video playback still depends on the Photos asset identifier.
        guard let assetID = mediaItem.assetID else { return }
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        guard let asset = assets.firstObject else { return }
        
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: options) { item, _ in
            if let item = item {
                DispatchQueue.main.async {
                    player = AVPlayer(playerItem: item)
                    player?.play()
                }
            }
        }
    }
}
