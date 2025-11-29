//
//  SettingsView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI
import Clerk
import Factory
import RevenueCat

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appearanceManager: AppearanceManager
    @Injected(\.storeKitService) private var storeKit
    @Injected(\.analyticsManager) private var analytics
    @Injected(\.playerLifecycleService) private var lifecycle
    @State private var showAuth = false
    @State private var showUserProfile = false
    @State private var showStore = false
    @State private var showTerms = false
    @State private var showHelp = false
    @State private var showMyGoals = false
    @State private var showAdventurerProfile = false
    @State private var hasAppliedPersonalityBaseline = UserDefaults.standard.bool(forKey: "SoloQuest.Onboarding.PersonalityBaselineApplied")
    @State private var isRestoringPurchases = false
    @State private var showRestoreAlert = false
    @State private var restoreAlertMessage = ""
    @State private var showClearDataConfirmation = false
    @State private var showClearDataFailureAlert = false
    
    private var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    private var currentYear: String {
        String(Calendar.current.component(.year, from: Date()))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brandBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsHeaderView(rank: viewModel.rank)

                        SettingsProfileSectionView(
                            showUserProfile: { showUserProfile = true },
                            showAuth: { showAuth = true },
                            showStore: { showStore = true },
                            showMyGoals: { showMyGoals = true },
                            showAdventurerProfile: { showAdventurerProfile = true },
                            canTakeAdventurerProfileAssessment: lifecycle.isEarlyJourneyEligible && !hasAppliedPersonalityBaseline
                        )
                        
                        SettingsPreferencesSectionView(
                            isNotificationsEnabled: $viewModel.isNotificationsEnabled,
                            isDarkModeEnabled: $viewModel.isDarkModeEnabled,
                            locationStatusTitle: viewModel.locationStatusTitle,
                            locationActionTitle: viewModel.locationActionTitle,
                            isRequestingLocation: viewModel.isRequestingLocation,
                            handleLocationPersonalizationTap: viewModel.handleLocationPersonalizationTap
                        )
                        
                        SettingsAboutSectionView(
                            isRestoringPurchases: isRestoringPurchases,
                            requestReview: { viewModel.requestReview() },
                            showHelp: { withAnimation { showHelp = true } },
                            showTerms: { showTerms = true },
                            restorePurchases: restorePurchases
                        )

                        SettingsDataSectionView(
                            isClearingData: viewModel.isClearingData,
                            requestClearData: { showClearDataConfirmation = true }
                        )
                        
                        SettingsSignOutButton(signOut: { viewModel.signOut() })
                        
                        SettingsFooterView(appVersion: appVersion, currentYear: currentYear)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top)
                    .frame(maxWidth: 640)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                if showHelp {
                    SettingsHelpModalView(
                        supportCode: storeKit.supportCode,
                        close: {
                            withAnimation { showHelp = false }
                        }
                    )
                }
            }
            .environment(\.colorScheme, appearanceManager.colorScheme)
            .navigationBarHidden(true)
            .sheet(isPresented: $showAuth) {
                AuthView()
            }
            .sheet(isPresented: $showUserProfile) {
                UserProfileView()
            }
            .sheet(isPresented: $showStore) {
                StoreView()
            }
            .sheet(isPresented: $showTerms) {
                LegalSheetView()
            }
            .sheet(isPresented: $showMyGoals) {
                MyGoalsView()
            }
            .sheet(isPresented: $showAdventurerProfile, onDismiss: {
                hasAppliedPersonalityBaseline = UserDefaults.standard.bool(forKey: "SoloQuest.Onboarding.PersonalityBaselineApplied")
            }) {
                AdventurerProfileAssessmentView()
            }
            .alert("Restore Purchases", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(restoreAlertMessage)
            }
            .alert("Clear All Data?", isPresented: $showClearDataConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear Data", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("This deletes quests, stats, goals, preferences, and saved adventure media from Solo Quest. Your account and purchases stay intact. This cannot be undone.")
            }
            .alert("Could Not Clear Data", isPresented: $showClearDataFailureAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.clearDataErrorMessage)
            }
        }
    }

    private func clearAllData() {
        let didClear = viewModel.clearAllData()

        if didClear {
            lifecycle.beginUsableLifecycleIfNeeded()
            dismiss()
        } else {
            showClearDataFailureAlert = true
        }
    }
    
    private func restorePurchases() {
        isRestoringPurchases = true
        analytics.track(event: "purchase_restore_started", properties: [
            "source": "settings"
        ])
        
        Task {
            do {
                let customerInfo = try await storeKit.restorePurchases()
                let isPro = customerInfo.entitlements["pro"]?.isActive == true
                analytics.track(event: "purchase_restore_completed", properties: [
                    "source": "settings",
                    "is_pro_active": isPro
                ])

                if isPro, let productId = customerInfo.entitlements["pro"]?.productIdentifier {
                    analytics.trackEntitlementActive(
                        entitlement: "pro",
                        productId: productId,
                        source: "settings_restore"
                    )
                }
                
                await MainActor.run {
                    isRestoringPurchases = false
                    if isPro {
                        restoreAlertMessage = String(localized: "Your Guild Pass has been restored successfully!")
                    } else {
                        restoreAlertMessage = String(localized: "No previous purchases found to restore.")
                    }
                    showRestoreAlert = true
                }
            } catch {
                analytics.track(event: "purchase_restore_failed", properties: [
                    "source": "settings",
                    "error_description": error.localizedDescription
                ])
                await MainActor.run {
                    isRestoringPurchases = false
                    restoreAlertMessage = String(localized: "Failed to restore purchases. Please try again.")
                    showRestoreAlert = true
                }
            }
        }
    }
}
