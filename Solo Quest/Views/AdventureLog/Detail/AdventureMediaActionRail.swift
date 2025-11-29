//
//  AdventureMediaActionRail.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import UIKit

struct AdventureMediaActionRail: View {
    let mediaItem: MediaItem
    let shareImage: UIImage?
    let onViewQuest: ((QuestInstance) -> Void)?
    let onShare: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 20) {
            Spacer()
            
            if let quest = mediaItem.quest {
                Button(action: {
                    onViewQuest?(quest)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "map.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                        Text("Quest")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                }
            }
            
            if let shareImage = shareImage {
                let shareText = "Quest Completed on Solo Quest XP."
                ShareLink(
                    item: Image(uiImage: shareImage),
                    message: Text(shareText),
                    preview: SharePreview("Quest Completed", image: Image(uiImage: shareImage))
                ) {
                    VStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                        Text("Share")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded(onShare))
            } else {
                ProgressView()
                    .tint(.white)
            }
        }
        .padding(.trailing, 16)
        .padding(.bottom, 60)
    }
}
