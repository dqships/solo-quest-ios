//
//  ReviewManager.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import Foundation
import StoreKit
import SwiftUI
import Factory

@MainActor
final class ReviewManager {
    private var reviewCount = 0
    private let maxReviewsPerSession = 3
    private let lastAutomaticReviewRequestKey = "SoloQuest.Review.LastAutomaticRequestDate"
    private let automaticReviewCooldown: TimeInterval = 120 * 24 * 60 * 60
    
    /// Requests a review prompt if the session limit hasn't been reached.
    func requestReview(delay: TimeInterval = 0.0) {
        // Early exit if already maxed
        guard reviewCount < maxReviewsPerSession else { return }
        
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self else { return }
                // Re-check limit at execution time
                guard self.reviewCount < self.maxReviewsPerSession else { return }
                
                self.triggerReview()
                self.reviewCount += 1
            }
        } else {
            triggerReview()
            reviewCount += 1
        }
    }

    /// First completion is reserved for the player reward. Request at a later, established win.
    func requestReviewIfEligible(
        questsCompletedLifetime: Int,
        activeDaysLifetime: Int,
        currentStreak: Int,
        level: Int
    ) {
        let hasEstablishedUse = questsCompletedLifetime >= 4 && activeDaysLifetime >= 3
        let hasPositiveMilestone = currentStreak >= 3 || level >= 5
        guard hasEstablishedUse && hasPositiveMilestone else { return }
        if let lastRequest = UserDefaults.standard.object(forKey: lastAutomaticReviewRequestKey) as? Date,
           Date().timeIntervalSince(lastRequest) < automaticReviewCooldown {
            return
        }
        UserDefaults.standard.set(Date(), forKey: lastAutomaticReviewRequestKey)
        requestReview(delay: 2.0)
    }
    
    /// Requests a review prompt immediately (e.g. from a button tap).
    func requestManualReview() {
        triggerReview()
    }
    
    private func triggerReview() {
        // Ensure we are on main thread
        Task { @MainActor in
            guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
                return
            }
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
