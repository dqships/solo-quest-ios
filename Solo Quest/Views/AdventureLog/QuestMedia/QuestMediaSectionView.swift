//
//  QuestMediaSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI
import CoreData
import Photos
import Factory

struct QuestMediaSectionView: View {
    @FetchRequest private var mediaItems: FetchedResults<MediaItem>
    private let thumbSize: CGFloat = 90

    init(quest: QuestInstance) {
        let scope = Container.shared.accountScopeProvider().activeScope
        let predicate: NSPredicate = isOwnedByActiveAccount(quest, scope: scope)
            ? accountScopedPredicate(NSPredicate(format: "quest == %@", quest), scope: scope)
            : NSPredicate(value: false)
        _mediaItems = FetchRequest(
            sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)],
            predicate: predicate,
            animation: .default
        )
    }

    var body: some View {
        if mediaItems.isEmpty {
            Text("No media captured yet.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.vertical, 8)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(mediaItems) { item in
                            NavigationLink {
                            AdventureMediaDetailView(mediaItem: item)
                            } label: {
                            AdventureAssetThumbnailView(mediaItem: item, size: thumbSize)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
