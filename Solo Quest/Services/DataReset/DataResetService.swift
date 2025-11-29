//
//  DataResetService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Factory
import Foundation

@MainActor
final class DataResetService {
    @Injected(\.persistenceController) var persistence
    @Injected(\.accountScopeProvider) var accountScopeProvider

    func clearAllData() throws {
        let mediaIDs = try activeMediaItemIDs()
        try deleteCoreDataRecords()
        clearUserDefaults()
        try clearLocalAdventureLogFiles(itemIDs: mediaIDs)
    }
}
