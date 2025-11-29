//
//  SettingsViewModel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI
import Combine
import Clerk
import Factory

@MainActor
class SettingsViewModel: ObservableObject {
    @Injected(\.notificationManager) private var notificationManager
    @Injected(\.reviewManager) private var reviewManager
    @Injected(\.userStatsManager) private var userStatsManager
    @Injected(\.appearanceManager) private var appearanceManager
    @Injected(\.locationService) private var locationService
    @Injected(\.analyticsIdentityService) private var analyticsIdentity
    @Injected(\.dataResetService) private var dataResetService
    
    @Published var rank: String = "E"
    @Published var isNotificationsEnabled: Bool = false {
        didSet {
            if isNotificationsEnabled != notificationManager.isDailyReminderEnabled {
                notificationManager.isDailyReminderEnabled = isNotificationsEnabled
            }
        }
    }
    @Published var isDarkModeEnabled: Bool = false {
        didSet {
            if isDarkModeEnabled != appearanceManager.isDarkModeEnabled {
                appearanceManager.isDarkModeEnabled = isDarkModeEnabled
            }
        }
    }
    @Published var locationAuthorizationState: LocationAuthorizationState = .unknown
    @Published var isRequestingLocation = false
    @Published var isClearingData = false
    @Published var clearDataErrorMessage = ""
    @Published var showHelpAlert: Bool = false
    @Published var showLegalSheet: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Sync initial state from managers
        self.isNotificationsEnabled = notificationManager.isDailyReminderEnabled
        self.isDarkModeEnabled = appearanceManager.isDarkModeEnabled
        self.locationAuthorizationState = locationService.authorizationState
        
        let stats = userStatsManager.getUserStats()
        self.rank = stats.rank ?? "E"
        
        // Observe manager changes (in case permissions change externally or logic updates)
        notificationManager.$isDailyReminderEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.isNotificationsEnabled = enabled
            }
            .store(in: &cancellables)
        
        appearanceManager.$isDarkModeEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.isDarkModeEnabled = enabled
            }
            .store(in: &cancellables)

        locationService.$authorizationState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.locationAuthorizationState = state
            }
            .store(in: &cancellables)
    }

    var locationStatusTitle: String {
        locationAuthorizationState.displayTitle
    }

    var locationActionTitle: String {
        locationAuthorizationState.settingsActionTitle
    }
    
    func requestReview() {
        reviewManager.requestManualReview()
    }

    func handleLocationPersonalizationTap() {
        switch locationAuthorizationState {
        case .notDetermined, .unknown:
            requestLocationPersonalization()
        case .denied, .restricted:
            locationService.openAppSettings()
        case .authorizedWhenInUse, .authorizedAlways:
            break
        }
    }

    func requestLocationPersonalization() {
        isRequestingLocation = true

        Task { [weak self] in
            guard let self else { return }

            _ = await locationService.requestLocationContext()
            locationService.markPersonalizationPromptSeen()
            locationAuthorizationState = locationService.authorizationState
            isRequestingLocation = false
        }
    }

    func clearAllData() -> Bool {
        guard !isClearingData else { return false }

        isClearingData = true
        clearDataErrorMessage = ""

        do {
            try dataResetService.clearAllData()
            notificationManager.isDailyReminderEnabled = false
            appearanceManager.isDarkModeEnabled = false
            rank = "E"
            isNotificationsEnabled = false
            isDarkModeEnabled = false
            isClearingData = false
            return true
        } catch {
            clearDataErrorMessage = error.localizedDescription
            isClearingData = false
            return false
        }
    }
    
    func signOut() {
        Task {
            do {
                try await Clerk.shared.signOut()
                await analyticsIdentity.clearLinkedIdentityIfNeeded()
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
}
