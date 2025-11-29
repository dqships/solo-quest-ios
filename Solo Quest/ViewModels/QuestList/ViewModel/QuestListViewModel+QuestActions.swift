//
//  QuestListViewModel+QuestActions.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension QuestListViewModel {
    func acceptQuest(_ quest: QuestInstance) {
        do {
            try questEngine.acceptQuest(quest)
            activeAnimation = .accepted
        } catch QuestEngine.QuestError.dailyLimitReached {
            presentDailyLimitToast()
        } catch QuestEngine.QuestError.questInProgress {
            showToast = true
            toastMessage = String(localized: "Finish your current quest first.")
            toastActionTitle = nil
            toastAction = nil
        } catch QuestEngine.QuestError.inaccessibleQuest {
            showToast = true
            toastMessage = String(localized: "This quest is no longer available for this account.")
            toastActionTitle = nil
            toastAction = nil
        } catch {
            print("❌ Accept failed: \(error)")
        }
    }

    func completeQuest(_ quest: QuestInstance) {
        do {
            pendingCompletionReward = try questEngine.completeQuest(quest)
            activeAnimation = .completed
        } catch QuestEngine.QuestError.dailyLimitReached {
            presentDailyLimitToast()
        } catch {
            print("❌ Complete failed: \(error)")
        }
    }

    func failQuest(_ quest: QuestInstance) {
        analytics.track(event: "quest_give_up_tapped", properties: [
            "quest_id": quest.id?.uuidString ?? "unknown",
            "quest_template_id": quest.questTemplateId ?? "unknown",
            "source": "quest_detail"
        ])
        questEngine.failQuest(quest)
        activeAnimation = .failed
    }

    func dismissCompletionReward() {
        let dismissedReward = completionReward
        let shouldOfferAfterReward = dismissedReward?.isFirstCompletion == true &&
            monetizationEligibility.isEligibleAfterFirstCompletion(isPro: storeKit.isPro)
        completionReward = nil
        if let dismissedReward, !dismissedReward.isFirstCompletion {
            reviewManager.requestReviewIfEligible(
                questsCompletedLifetime: questEngine.completedQuestCount(context: persistence.container.viewContext),
                activeDaysLifetime: lifecycle.activeDaysLifetime,
                currentStreak: user?.streakDays ?? 0,
                level: dismissedReward.level
            )
        }
        if shouldOfferAfterReward {
            monetizationEligibility.recordFirstCompletionOffer()
            storeSource = .firstCompletion
            openStoreSheet = true
        }
    }

    func finishAnimation() {
        let finishedAnimation = activeAnimation
        activeAnimation = nil
        if finishedAnimation == .completed {
            completionReward = pendingCompletionReward
            pendingCompletionReward = nil
        }
    }

    func dismissModal() {
        activeModal = nil
    }
}
