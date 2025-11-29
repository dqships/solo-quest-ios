//
//  StatsViewModel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Combine
import CoreData
import Factory
import Foundation

class StatsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Injected(\.persistenceController) var persistence
    @Injected(\.questEngine) var questEngine
    @Injected(\.reviewManager) var reviewManager
    @Injected(\.playerLifecycleService) var lifecycle
    @Injected(\.accountScopeProvider) var accountScopeProvider

    @Published var user: UserProfile?
    @Published var levelProgress: Double = 0.0
    @Published var currentLevelXP: Int = 0
    @Published var nextLevelXP: Int = 100
    @Published var showLevelUpAnimation: Bool = false
    @Published var previousLevel: Int = 1
    @Published var newLevel: Int = 1
    @Published var showRankUpAnimation: Bool = false
    @Published var previousRank: String = "E"
    @Published var newRank: String = "E"

    var pendingRankUp: Bool = false
    var statsFRC: NSFetchedResultsController<UserStats>?
    var activityFRC: NSFetchedResultsController<ActivityLog>?

    override init() {
        super.init()
        setupCoreData()
    }
}
