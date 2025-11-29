//
//  LegalData+TermsOfService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 11-03-2026
//

import Foundation

extension LegalData {
    static var termsOfService: String {
        LocalizationService.localizedTermsOfService(fallback: defaultTermsOfService)
    }

    private static let defaultTermsOfService = """
    # Terms of Service
    Template. Replace this text with your own terms before you ship a build of Solo Quest XP.

    ## Use of the app
    Solo Quest XP gives you daily real-world quests and tracks your progress with XP, stats, and ranks. Do only the quests that are safe and legal for you.

    ## Purchases
    Subscriptions and purchases, when set up, are handled by the App Store and RevenueCat.

    ## No warranty
    The app is provided "as is", without warranty of any kind.

    ## Contact
    support@example.com
    """
}
