//
//  QuestEngine+QuestActions.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import CoreData
import Foundation

extension QuestEngine {
    func acceptQuest(_ quest: QuestInstance) throws {
        guard isOwnedByActiveAccount(quest, scope: accountScopeProvider.activeScope) else {
            print("⚠️ QuestEngine: Refused cross-account quest mutation")
            throw QuestError.inaccessibleQuest
        }
        let context = persistence.container.viewContext
        let dateAssigned = quest.dateAssigned ?? Date()

        if let gameDay = gameDayBounds(containing: dateAssigned) {
            let otherQuests = fetchQuestInstances(
                context: context,
                start: gameDay.start,
                end: gameDay.end,
                isSideQuest: quest.isSideQuest
            ).filter { $0.objectID != quest.objectID }

            if otherQuests.contains(where: { $0.state == "locked" || $0.state == "active" }) {
                throw QuestError.questInProgress
            }

            if quest.isSideQuest {
                if otherQuests.contains(where: { $0.state == "completed" }) {
                    throw QuestError.dailyLimitReached
                }
            } else if finishedDailyQuestCount(
                context: context,
                start: gameDay.start,
                end: gameDay.end,
                excluding: quest
            ) >= dailyQuestLimit() {
                throw QuestError.dailyLimitReached
            }
        }

        let userStats = fetchOrCreateUserStats(context: context)
        userStats.lastQuestEngagementDate = Date()
        let isFirstQuest = isFirstQuestStart(quest, context: context)

        guard let data = gameData, let templateId = quest.questTemplateId, let template = getTemplate(id: templateId) else {
            quest.state = "active"
            quest.startTime = Date()
            analytics.track(event: "quest_started", properties: QuestAnalyticsProperties.make(
                quest: quest,
                userStats: userStats,
                isPro: storeKit.isPro,
                isFirstQuest: isFirstQuest,
                source: "quest_detail",
                extra: retentionAnalyticsProperties(context: context)
            ))
            if isFirstQuest && lifecycle.shouldTrackFirstEvent("first_quest_started") {
                analytics.track(event: "first_quest_started", properties: QuestAnalyticsProperties.make(
                    quest: quest,
                    userStats: userStats,
                    isPro: storeKit.isPro,
                    isFirstQuest: true,
                    source: "quest_detail",
                    extra: retentionAnalyticsProperties(context: context)
                ))
            }
            saveContext()
            return
        }

        let size = template.size
        let durationConfig = data.config.questSizeDurations[size] ?? QuestDuration(minMinutes: 15, maxMinutes: 15, defaultTimerMinutes: 15)
        let durationMinutes = durationConfig.defaultTimerMinutes
        let unlockSeconds = TimeInterval(data.config.timerConfig.completionUnlockSeconds)

        let now = Date()
        let durationSeconds = TimeInterval(durationMinutes * 60)

        quest.state = "locked"
        quest.startTime = now
        quest.expiryTime = now.addingTimeInterval(durationSeconds)
        quest.activationTime = now.addingTimeInterval(unlockSeconds)

        print("✅ Accepted Quest: Locked until \(quest.activationTime!)")

        let properties = QuestAnalyticsProperties.make(
            quest: quest,
            userStats: userStats,
            isPro: storeKit.isPro,
            isFirstQuest: isFirstQuest,
            source: "quest_detail",
            template: template,
            extra: retentionAnalyticsProperties(context: context).merging([
                "quest_difficulty": template.size,
                "matches_all_preferences": matchesAllPreferences(quest: template, filterPrefs: filterPreferences)
            ], uniquingKeysWith: { _, new in new })
        )
        analytics.track(event: "quest_started", properties: properties)
        if isFirstQuest && lifecycle.shouldTrackFirstEvent("first_quest_started") {
            analytics.track(event: "first_quest_started", properties: properties)
        }
        if let expiryTime = quest.expiryTime {
            retentionNotifications.scheduleActiveQuestReminder(
                questID: quest.id?.uuidString ?? quest.questTemplateId ?? "unknown",
                questTitle: quest.generatedTitle ?? String(localized: "Active quest"),
                expiry: expiryTime
            )
        }

        saveContext()
    }

    func completeQuest(_ quest: QuestInstance) throws -> QuestCompletionReward? {
        guard isOwnedByActiveAccount(quest, scope: accountScopeProvider.activeScope) else { print("⚠️ QuestEngine: Refused cross-account quest mutation"); return nil }
        guard quest.state == "active" else {
            print("⚠️ Cannot complete quest in state: \(quest.state ?? "nil")")
            return nil
        }

        let context = persistence.container.viewContext
        if !quest.isSideQuest,
           let gameDay = gameDayBounds(containing: quest.dateAssigned ?? Date()),
           finishedDailyQuestCount(
                context: context,
                start: gameDay.start,
                end: gameDay.end,
                excluding: quest
           ) >= dailyQuestLimit() {
            throw QuestError.dailyLimitReached
        }

        let userStats = fetchOrCreateUserStats(context: context)
        userStats.lastQuestEngagementDate = Date()
        let isFirstQuest = isFirstQuestCompletion(quest, context: context)

        quest.state = "completed"
        quest.completionTime = Date()

        let baseXP = Int64(quest.xpReward)
        let xp = awardedXP(forBaseXP: baseXP)
        let primaryStat = quest.primaryStat ?? "resilience"
        let statXPBefore = statXP(for: primaryStat, in: userStats)
        let levelBefore = Int(userStats.level)
        let rankBefore = userStats.rank ?? "E"
        let levelProgressBefore = getLevelProgress(totalXP: userStats.totalXP).progress

        userStats.totalXP += xp
        applyStatXP(to: userStats, stat: quest.primaryStat, amount: xp)

        let secondaryXP = xp / 2
        if let secondaries = quest.secondaryStats?.split(separator: ",") {
            for stat in secondaries {
                applyStatXP(to: userStats, stat: String(stat).trimmingCharacters(in: .whitespaces), amount: secondaryXP)
            }
        }

        checkLevelUp(userStats)
        let statXPAfter = statXP(for: primaryStat, in: userStats)

        logActivity(
            context: context,
            note: "Completed: \(quest.generatedTitle ?? "Quest")",
            xp: Int(xp),
            quest: quest
        )

        let template = quest.questTemplateId.flatMap { getTemplate(id: $0) }
        let difficulty = template?.size ?? "unknown"
        let properties = QuestAnalyticsProperties.make(
            quest: quest,
            userStats: userStats,
            isPro: storeKit.isPro,
            isFirstQuest: isFirstQuest,
            source: "quest_detail",
            template: template,
            extra: retentionAnalyticsProperties(context: context).merging([
                "quest_difficulty": difficulty,
                "base_xp": Int(baseXP),
                "xp_earned": Int(xp),
                "xp_multiplier": Int(xpRewardMultiplier),
                "double_xp_active": isDoubleXPActive,
                "stats_gained": [quest.primaryStat ?? "unknown": Double(xp)],
                "matches_all_preferences": quest.questTemplateId.flatMap { getTemplate(id: $0) }.map {
                    matchesAllPreferences(quest: $0, filterPrefs: filterPreferences)
                } ?? false,
                "new_user_protection_active": newPlayerProtection.isActive()
            ], uniquingKeysWith: { _, new in new })
        )
        analytics.track(event: "quest_completed", properties: properties)
        if isFirstQuest && lifecycle.shouldTrackFirstEvent("first_quest_completed") {
            analytics.track(event: "first_quest_completed", properties: properties)
            lifecycle.recordFirstCompletion()
        }

        saveContext()
        let levelProgressAfter = getLevelProgress(totalXP: userStats.totalXP).progress
        return QuestCompletionReward(
            id: quest.id ?? UUID(),
            questTitle: quest.generatedTitle ?? String(localized: "Quest"),
            questTemplateID: quest.questTemplateId ?? "unknown",
            questCategory: template?.category?.rawValue ?? "unknown",
            questDifficulty: difficulty,
            xpEarned: Int(xp),
            primaryStat: primaryStat,
            statXPBefore: statXPBefore,
            statXPAfter: statXPAfter,
            levelBefore: levelBefore,
            level: Int(userStats.level),
            rankBefore: rankBefore,
            rank: userStats.rank ?? "E",
            levelProgressBefore: levelProgressBefore,
            levelProgressAfter: levelProgressAfter,
            isFirstCompletion: isFirstQuest,
            userTotalXP: Int(userStats.totalXP),
            userCurrentStreak: Int(userStats.currentStreak),
            activeDaysLifetime: lifecycle.activeDaysLifetime,
            daysSinceInstall: lifecycle.daysSinceInstall(),
            newUserProtectionActive: newPlayerProtection.isActive()
        )
    }



    func failQuest(_ quest: QuestInstance) {
        guard isOwnedByActiveAccount(quest, scope: accountScopeProvider.activeScope) else { print("⚠️ QuestEngine: Refused cross-account quest mutation"); return }
        guard quest.state != "completed" && quest.state != "failed" else { return }

        let context = persistence.container.viewContext
        let userStats = fetchOrCreateUserStats(context: context)
        userStats.lastQuestEngagementDate = Date()
        let isFirstQuest = isFirstQuestStart(quest, context: context)

        quest.state = "failed"
        quest.completionTime = Date()

        let penalty = Int64(Double(quest.xpReward) * 0.5)
        let protectionActive = newPlayerProtection.isActive()

        if !protectionActive {
            userStats.totalXP = max(0, userStats.totalXP - penalty)
        }
        checkLevelUp(userStats)

        logActivity(
            context: context,
            note: "Failed: \(quest.generatedTitle ?? "Quest")",
            xp: protectionActive ? 0 : -Int(penalty),
            quest: quest
        )

        let difficulty = quest.questTemplateId.flatMap { getTemplate(id: $0)?.size } ?? "unknown"
        let properties = QuestAnalyticsProperties.make(
            quest: quest,
            userStats: userStats,
            isPro: storeKit.isPro,
            isFirstQuest: isFirstQuest,
            source: "quest_detail",
            extra: retentionAnalyticsProperties(context: context).merging([
                "quest_difficulty": difficulty,
                "xp_lost": protectionActive ? 0 : Int(penalty),
                "immune": protectionActive,
                "penalty_prevented": protectionActive,
                "penalty_prevented_reason": newPlayerProtection.protectedPenaltyReason() ?? "none",
                "new_user_protection_active": protectionActive
            ], uniquingKeysWith: { _, new in new })
        )
        analytics.track(event: "quest_failed", properties: properties)
        if isFirstQuest && lifecycle.shouldTrackFirstEvent("first_quest_failed") {
            analytics.track(event: "first_quest_failed", properties: properties)
        }

        saveContext()
    }
}
