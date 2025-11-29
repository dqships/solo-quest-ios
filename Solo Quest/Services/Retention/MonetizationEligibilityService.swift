//
//  MonetizationEligibilityService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

@MainActor
final class MonetizationEligibilityService {
    private let firstCompletionOfferKey = "SoloQuest.Retention.FirstCompletionPaywallOffered"

    func isEligibleAfterFirstCompletion(isPro: Bool) -> Bool {
        RetentionFeatureFlags.isFirstCompletionPaywallEnabled &&
        !isPro &&
        !UserDefaults.standard.bool(forKey: firstCompletionOfferKey)
    }

    func recordFirstCompletionOffer() {
        UserDefaults.standard.set(true, forKey: firstCompletionOfferKey)
    }
}
