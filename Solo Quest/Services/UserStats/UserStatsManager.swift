//
//  UserStatsManager.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation
import Factory

@MainActor
class UserStatsManager {
    @Injected(\.persistenceController) var persistence
    @Injected(\.accountScopeProvider) var accountScopeProvider
}
