//
//  NewPlayerProtectionService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

@MainActor
final class NewPlayerProtectionService {
    private let lifecycle: PlayerLifecycleService

    init(lifecycle: PlayerLifecycleService) {
        self.lifecycle = lifecycle
    }

    func isActive(at date: Date = Date()) -> Bool {
        guard lifecycle.isEarlyJourneyEligible,
              let startedAt = lifecycle.usableStartedAt else { return false }
        let days = Calendar.current.dateComponents([.day], from: startedAt, to: date).day ?? 0
        return days < RetentionFeatureFlags.newPlayerProtectionDurationDays
    }

    func protectedPenaltyReason(at date: Date = Date()) -> String? {
        isActive(at: date) ? "new_player_protection" : nil
    }

    func daysRemaining(at date: Date = Date()) -> Int {
        guard let startedAt = lifecycle.usableStartedAt else { return 0 }
        let elapsed = max(0, Calendar.current.dateComponents([.day], from: startedAt, to: date).day ?? 0)
        return max(0, RetentionFeatureFlags.newPlayerProtectionDurationDays - elapsed)
    }
}
