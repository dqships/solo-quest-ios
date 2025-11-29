//
//  StatsViewModel+Animations.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Foundation
import SwiftUI

extension StatsViewModel {
    func checkForLevelUp(currentLevel: Int) {
        let lastSeenLevel = UserDefaults.standard.integer(forKey: "lastSeenLevel")
        if lastSeenLevel == 0 {
            UserDefaults.standard.set(currentLevel, forKey: "lastSeenLevel")
        } else if currentLevel > lastSeenLevel {
            DispatchQueue.main.async {
                self.previousLevel = lastSeenLevel
                self.newLevel = currentLevel
                self.showLevelUpAnimation = true
            }
        }
    }

    func checkForRankUp(currentRank: String) {
        let lastSeenRank = UserDefaults.standard.string(forKey: "lastSeenRank") ?? ""

        if lastSeenRank.isEmpty {
            UserDefaults.standard.set(currentRank, forKey: "lastSeenRank")
        } else if currentRank != lastSeenRank && isRankHigher(currentRank, than: lastSeenRank) {
            DispatchQueue.main.async {
                self.previousRank = lastSeenRank
                self.newRank = currentRank

                if self.showLevelUpAnimation {
                    self.pendingRankUp = true
                } else {
                    self.showRankUpAnimation = true
                }
            }
        }
    }

    func isRankHigher(_ newRank: String, than oldRank: String) -> Bool {
        let rankOrder = ["E", "D", "C", "B", "A", "S"]
        guard let newIndex = rankOrder.firstIndex(of: newRank),
              let oldIndex = rankOrder.firstIndex(of: oldRank) else {
            return false
        }
        return newIndex > oldIndex
    }

    func markLevelUpSeen() {
        if let level = user?.level {
            UserDefaults.standard.set(level, forKey: "lastSeenLevel")
            withAnimation {
                showLevelUpAnimation = false
            }

            if pendingRankUp {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.pendingRankUp = false
                    self.showRankUpAnimation = true
                }
            } else {
                requestMilestoneReviewIfEligible()
            }
        }
    }

    func markRankUpSeen() {
        UserDefaults.standard.set(newRank, forKey: "lastSeenRank")
        withAnimation {
            showRankUpAnimation = false
        }
        requestMilestoneReviewIfEligible()
    }

    private func requestMilestoneReviewIfEligible() {
        guard let user else { return }
        reviewManager.requestReviewIfEligible(
            questsCompletedLifetime: questEngine.completedQuestCount(context: persistence.container.viewContext),
            activeDaysLifetime: lifecycle.activeDaysLifetime,
            currentStreak: user.streakDays,
            level: user.level
        )
    }
}
