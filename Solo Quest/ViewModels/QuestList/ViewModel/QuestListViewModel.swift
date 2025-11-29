//
//  QuestListViewModel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Combine
import CoreData
import Factory
import Foundation

@MainActor
class QuestListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    typealias ModalType = QuestListModalType
    typealias QuestAnimationEvent = QuestListAnimationEvent

    @Injected(\.persistenceController) var persistence
    @Injected(\.questEngine) var questEngine
    @Injected(\.reviewManager) var reviewManager
    @Injected(\.analyticsManager) var analytics
    @Injected(\.storeKitService) var storeKit
    @Injected(\.playerLifecycleService) var lifecycle
    @Injected(\.monetizationEligibilityService) var monetizationEligibility
    @Injected(\.retentionNotificationCoordinator) var retentionNotifications
    @Injected(\.accountScopeProvider) var accountScopeProvider

    @Published var user: UserProfile?
    @Published var levelProgress: Double = 0.0
    @Published var currentLevelXP: Int = 0
    @Published var nextLevelXP: Int = 100
    @Published var dailyQuests: [QuestInstance] = []
    @Published var activityFetchLimit: Int = 20
    @Published var activeModal: ModalType?
    @Published var activeAnimation: QuestAnimationEvent?
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastActionTitle: String?
    @Published var toastAction: (() -> Void)?
    @Published var openStoreSheet: Bool = false
    @Published var openAuthSheet: Bool = false
    @Published var isShowingRerollReasons = false
    @Published var completionReward: QuestCompletionReward?
    var pendingCompletionReward: QuestCompletionReward?
    @Published var storeSource: PaywallSource = .store

    var questsFRC: NSFetchedResultsController<QuestInstance>?
    var statsFRC: NSFetchedResultsController<UserStats>?
    var activityFRC: NSFetchedResultsController<ActivityLog>?
    var timerCancellable: AnyCancellable?

    override init() {
        super.init()
        setupCoreData()
        checkDailyReset()
        if AppStoreScreenshotMode.isEnabled, AppStoreScreenshotMode.screen == .questOfTheDay {
            activeAnimation = .completed
        }
        startTimer()
    }

    deinit {
        timerCancellable?.cancel()
    }
}
