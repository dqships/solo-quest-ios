//
//  AdventureAlbumManager.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Factory
import Foundation

@MainActor
final class AdventureAlbumManager {
    static let shared = AdventureAlbumManager()
    private init() {}

    @Injected(\.accountScopeProvider) var accountScopeProvider
    @Injected(\.analyticsManager) var analytics
    let albumTitle = "Solo Quest - Adventure Log"
}
