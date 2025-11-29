//
//  Solo_QuestApp.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 11-03-2026
//

import SwiftUI
import UIKit
import CoreData
import Factory
import Clerk

@main
struct Solo_QuestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = Container.shared.persistenceController()
    @Injected(\.analyticsManager) private var analytics
    @Injected(\.analyticsIdentityService) private var analyticsIdentity
    
    // Clerk
    @State private var clerk = Clerk.shared
    
    @StateObject private var appearanceManager = AppearanceManager.shared
    @StateObject private var appUpdateGateViewModel = AppUpdateGateViewModel()
    @StateObject private var accountScopeProvider = Container.shared.accountScopeProvider()
    @StateObject private var accountDataCoordinator = Container.shared.accountDataBootstrapCoordinator()
    
    @State private var showLaunchScreen = !AppStoreScreenshotMode.isEnabled
    @State private var hasCompletedInitialClerkLoadAttempt = false

    private var shouldShowLaunchScreen: Bool {
        guard !AppStoreScreenshotMode.isEnabled else { return false }
        return showLaunchScreen || !appUpdateGateViewModel.hasCompletedInitialCheck
    }
    
    // Initialize Engine
    init() {
        guard !AppRuntimeMode.isRunningXCTest else { return }


        if AppStoreScreenshotMode.isEnabled {
            Container.shared.accountScopeProvider().activateTransientScope(
                ownerID: AppStoreScreenshotFixtureOwner.ownerID
            )
            let persistenceController = Container.shared.persistenceController()
            let questEngine = Container.shared.questEngine()
            AppStoreScreenshotFixtureSeeder.prepare(
                screen: AppStoreScreenshotMode.screen,
                context: persistenceController.container.viewContext,
                questEngine: questEngine
            )
        } else {
            SoloQuestAppBootstrap.configureStartupServices()
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if AppStoreScreenshotMode.isEnabled {
                    AppStoreScreenshotRootView(screen: AppStoreScreenshotMode.screen)
                        .onAppear {
                            AppDelegate.orientationLock = .portrait
                        }
                } else if shouldShowLaunchScreen {
                    LaunchScreenView()
                    //    .transition(.opacity) // Transition handled in logic
                } else if let requiredUpdate = appUpdateGateViewModel.requiredUpdate {
                    AppUpdateRequiredView(
                        updateInfo: requiredUpdate,
                        updateAction: appUpdateGateViewModel.openAppStoreForRequiredUpdate
                    )
                } else if !accountDataCoordinator.isLocallyReady {
                    AccountDataPreparationView(
                        message: accountDataCoordinator.errorMessage ?? AccountDataBootstrapCopy.preparing,
                        canRetry: accountDataCoordinator.canRetry,
                        retryAction: accountDataCoordinator.retryCurrentAuth
                    )
                } else {
                    MainTabView()
                        .id(accountScopeProvider.activeScope.viewIdentity)
                        .onAppear {
                            AppDelegate.orientationLock = .all
                            Container.shared.playerLifecycleService().beginUsableLifecycleIfNeeded()
                        }
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.clerk, clerk)
            .environmentObject(appearanceManager)
            .environmentObject(accountScopeProvider)
            .preferredColorScheme(AppStoreScreenshotMode.isEnabled || shouldShowLaunchScreen ? .light : appearanceManager.colorScheme)
            .task {
                guard !AppStoreScreenshotMode.isEnabled, !AppRuntimeMode.isRunningXCTest else { return }
                await appUpdateGateViewModel.checkForUpdate()
            }
            .task {
                guard !AppStoreScreenshotMode.isEnabled, !AppRuntimeMode.isRunningXCTest else { return }
                await SoloQuestClerkLoader.load(clerk)
                hasCompletedInitialClerkLoadAttempt = true
                accountDataCoordinator.requestResolvedAuth(clerkUserID: Clerk.shared.user?.id)
                await analyticsIdentity.syncCurrentUser()
            }
            .onAppear {
                guard !AppStoreScreenshotMode.isEnabled, !AppRuntimeMode.isRunningXCTest else { return }
                analytics.trackAppOpened(fromBackground: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + LaunchScreenTiming.dismissalDelay) {
                    withAnimation {
                        showLaunchScreen = false
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                guard !AppStoreScreenshotMode.isEnabled, !AppRuntimeMode.isRunningXCTest else { return }
                analytics.trackAppOpened(fromBackground: true)

                Task {
                    await appUpdateGateViewModel.checkForUpdate()
                }
            }
            .onChange(of: clerk.user) { _, user in
                guard !AppStoreScreenshotMode.isEnabled, !AppRuntimeMode.isRunningXCTest else { return }
                guard hasCompletedInitialClerkLoadAttempt else { return }
                Task {
                    accountDataCoordinator.requestResolvedAuth(clerkUserID: user?.id)
                    await analyticsIdentity.sync(user: user)
                }
            }
        }
    }
}
