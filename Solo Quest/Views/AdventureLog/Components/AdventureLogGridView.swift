//
//  AdventureLogGridView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct AdventureLogGridView: View {
    let columns: [GridItem]
    let mediaItems: FetchedResults<MediaItem>
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(mediaItems) { item in
                NavigationLink(value: AppRoute.adventureMediaFeed(initialItem: item)) {
                    AdventureAssetThumbnailView(mediaItem: item, size: 110)
                }
            }
        }
        .padding(.horizontal)
    }
}
