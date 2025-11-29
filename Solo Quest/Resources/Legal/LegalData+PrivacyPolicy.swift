//
//  LegalData+PrivacyPolicy.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 11-03-2026
//

import Foundation

extension LegalData {
    static var privacyPolicy: String {
        LocalizationService.localizedPrivacyPolicy(fallback: defaultPrivacyPolicy)
    }

    private static let defaultPrivacyPolicy = """
    # Privacy Policy
    Template. Replace this text with your own privacy policy before you ship a build of Solo Quest XP.

    ## Data on your device
    Your quests, stats, streaks, notes, and Adventure Log photos and videos are stored on your device. When iCloud is turned on, the app syncs this data to your private iCloud account with CloudKit.

    ## Optional services
    Each service below runs only when its key or URL is set in Config/Secrets.xcconfig.
    * Clerk: sign-in and your account email.
    * RevenueCat: purchases and subscription status.
    * PostHog: app usage events for analytics.

    ## Location
    If you allow location access, the app uses your approximate location on your device to suggest nearby quests.

    ## Contact
    support@example.com
    """
}
