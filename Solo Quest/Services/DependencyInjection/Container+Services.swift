//
//  Container+Services.swift
//  Solo Quest
//
//  Created by DaQuan Louden on 05-01-2026
//

import Foundation
import Factory
import Combine

extension Container {
    var questEngine: Factory<QuestEngine> {
        self {
            MainActor.assumeIsolated {
                QuestEngine()
            }
        }.singleton
    }



    var locationService: Factory<LocationService> {
        self {
            MainActor.assumeIsolated {
                LocationService()
            }
        }.singleton
    }
    
    var persistenceController: Factory<PersistenceController> {
        self {
            MainActor.assumeIsolated {
                #if DEBUG
                if AppStoreScreenshotMode.isEnabled {
                    return PersistenceController.appStoreScreenshots
                }
                #endif

                return PersistenceController.shared
            }
        }.singleton
    }
    
    var notificationManager: Factory<NotificationManager> {
        self {
            MainActor.assumeIsolated {
                NotificationManager.shared
            }
        }.singleton
    }

    var retentionNotificationCoordinator: Factory<RetentionNotificationCoordinator> {
        self {
            MainActor.assumeIsolated {
                RetentionNotificationCoordinator(
                    notificationManager: self.notificationManager(),
                    lifecycle: self.playerLifecycleService()
                )
            }
        }.singleton
    }
    
    var reviewManager: Factory<ReviewManager> {
        self {
            MainActor.assumeIsolated {
                ReviewManager()
            }
        }.singleton
    }

    var playerLifecycleService: Factory<PlayerLifecycleService> {
        self {
            MainActor.assumeIsolated {
                PlayerLifecycleService()
            }
        }.singleton
    }

    var newPlayerProtectionService: Factory<NewPlayerProtectionService> {
        self {
            MainActor.assumeIsolated {
                NewPlayerProtectionService(lifecycle: self.playerLifecycleService())
            }
        }.singleton
    }

    var firstWeekRecapService: Factory<FirstWeekRecapService> {
        self {
            MainActor.assumeIsolated {
                FirstWeekRecapService(
                    persistence: self.persistenceController(),
                    lifecycle: self.playerLifecycleService(),
                    accountScopeProvider: self.accountScopeProvider()
                )
            }
        }.singleton
    }

    var monetizationEligibilityService: Factory<MonetizationEligibilityService> {
        self {
            MainActor.assumeIsolated {
                MonetizationEligibilityService()
            }
        }.singleton
    }

    var appUpdateService: Factory<AppUpdateService> {
        self {
            MainActor.assumeIsolated {
                AppUpdateService()
            }
        }.singleton
    }
    
    var storeKitService: Factory<StoreKitService> {
        self {
            MainActor.assumeIsolated {
                RevenueCatConfigurator.configureIfNeeded()
                return StoreKitService(skipRevenueCat: AppStoreScreenshotMode.isEnabled)
            }
        }.singleton
    }
        
    var userStatsManager: Factory<UserStatsManager> {
        self {
            MainActor.assumeIsolated {
                UserStatsManager()
            }
        }.singleton
    }

    var accountScopeProvider: Factory<AccountScopeProvider> {
        self { MainActor.assumeIsolated { AccountScopeProvider() } }.singleton
    }

    var legacyUpgradeEligibilityStore: Factory<LegacyUpgradeEligibilityStore> {
        self {
            MainActor.assumeIsolated {
                LegacyUpgradeEligibilityStore()
            }
        }.singleton
    }

    var accountDataBootstrapCoordinator: Factory<AccountDataBootstrapCoordinator> {
        self {
            MainActor.assumeIsolated {
                AccountDataBootstrapCoordinator(
                    persistence: self.persistenceController(),
                    accountScopeProvider: self.accountScopeProvider(),
                    eligibilityStore: self.legacyUpgradeEligibilityStore()
                )
            }
        }.singleton
    }

    var dataResetService: Factory<DataResetService> {
        self {
            MainActor.assumeIsolated {
                DataResetService()
            }
        }.singleton
    }
    
    var analyticsManager: Factory<AnalyticsManager> {
        self {
            MainActor.assumeIsolated {
                AnalyticsManager.shared
            }
        }.singleton
    }

    var analyticsIdentityService: Factory<AnalyticsIdentityService> {
        self {
            MainActor.assumeIsolated {
                AnalyticsIdentityService()
            }
        }.singleton
    }

    
    var appearanceManager: Factory<AppearanceManager> {
        self {
            MainActor.assumeIsolated {
                AppearanceManager.shared
            }
        }.singleton
    }
}
