//
//  DataResetUserDefaultsKey.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Foundation

enum DataResetUserDefaultsKey: String, CaseIterable {
    case firstQuestSeen = "SoloQuest.Analytics.FirstQuestSeen"
    case hasCompletedOnboarding
    case hasSeenLocationPersonalizationPrompt = "SoloQuest.HasSeenLocationPersonalizationPrompt"
    case isDailyReminderEnabled
    case isDarkModeEnabled
    case lastKnownNotificationStatus
    case lastSeenLevel
    case lastSeenRank
    case onboardingStep
    case personalityBaselineApplied = "SoloQuest.Onboarding.PersonalityBaselineApplied"
    case questFilterPreferences = "SoloQuest.QuestFilterPreferences"
    case retentionUsableStartedAt = "SoloQuest.Retention.UsableStartedAt"
    case retentionFirstEvents = "SoloQuest.Retention.FirstEvents"
    case retentionActiveGameDays = "SoloQuest.Retention.ActiveGameDays"
    case retentionFirstCompletionAt = "SoloQuest.Retention.FirstCompletionAt"
    case retentionRerollsToday = "SoloQuest.Retention.RerollsToday"
    case retentionRerollsTodayDay = "SoloQuest.Retention.RerollsToday.day"
    case retentionRerollsLifetime = "SoloQuest.Retention.RerollsLifetime"
    case retentionRerollFeedback = "SoloQuest.Retention.RerollFeedback"
    case retentionRerollFeedbackGameDay = "SoloQuest.Retention.RerollFeedbackGameDay"
    case retentionFirstCompletionPaywallOffered = "SoloQuest.Retention.FirstCompletionPaywallOffered"
    case retentionNotificationSignature = "SoloQuest.Retention.NotificationSignature"
    case retentionActiveQuestNotificationID = "SoloQuest.Retention.ActiveQuestNotificationID"
    case retentionEarlyJourneyEligible = "SoloQuest.Retention.EarlyJourneyEligible"
}
