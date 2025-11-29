//
//  AdventureLogView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Updated by DaQuan Louden on 05-29-2026
//

import CoreData
import Factory
import SwiftUI

struct AdventureLogView: View {
    @Injected(\.analyticsManager) private var analytics
    @Injected(\.playerLifecycleService) private var lifecycle
    @Binding var path: NavigationPath

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)],
        predicate: accountOwnedPredicate(Container.shared.accountScopeProvider().activeScope),
        animation: .default)
    private var mediaItems: FetchedResults<MediaItem>

    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 8)
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.brandBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        AdventureLogHeaderView()
                        
                        if mediaItems.isEmpty {
                            EmptyAdventureLogView()
                        } else {
                            AdventureLogGridView(columns: columns, mediaItems: mediaItems)
                        }
                    }
                    .padding(.top)
                    .frame(maxWidth: 1000)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .navigationBarHidden(true)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .adventureMediaFeed(let initialItem):
                        AdventureMediaFeedView(initialItem: initialItem, mediaItems: mediaItems)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear {
            analytics.trackMeaningfulActiveDay(source: "adventure_log", lifecycle: lifecycle)
        }
    }
}
