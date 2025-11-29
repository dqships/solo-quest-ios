//
//  AdventureMediaFeedView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI
import CoreData
import Photos

struct AdventureMediaFeedView: View {
    let initialItemID: UUID?
    let mediaItems: FetchedResults<MediaItem>
    
    @State private var currentID: UUID?
    
    init(initialItem: MediaItem, mediaItems: FetchedResults<MediaItem>) {
        self.initialItemID = initialItem.id
        self.mediaItems = mediaItems
        _currentID = State(initialValue: initialItem.id)
    }
    
    @Environment(\.dismiss) var dismiss
    
    // State to handle navigation to quest details
    @State private var selectedQuest: QuestInstance?
    @State private var showingQuestDetail = false
    
    // ... init ...
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(mediaItems) { item in
                    if let id = item.id {
                        AdventureMediaDetailView(mediaItem: item) { quest in
                            selectedQuest = quest
                            showingQuestDetail = true
                        }
                            .containerRelativeFrame([.horizontal, .vertical])
                            .id(id)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentID)
        .ignoresSafeArea()
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingQuestDetail) {
            if let quest = selectedQuest {
                NavigationView {
                    QuestDetailView(instance: quest, template: nil) // Template might be needed if not persisted in instance fully
                }
            }
        }
    }
}

