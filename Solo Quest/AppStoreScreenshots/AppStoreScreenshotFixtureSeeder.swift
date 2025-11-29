//
//  AppStoreScreenshotFixtureSeeder.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-29-2026
//

import CoreData
import Foundation

enum AppStoreScreenshotFixtureSeeder {
    static func prepare(screen: AppStoreScreenshotScreen, context: NSManagedObjectContext, questEngine: QuestEngine) {
        #if DEBUG
        guard AppStoreScreenshotMode.isEnabled else { return }

        UserDefaults.standard.set(false, forKey: "isDarkModeEnabled")

        clearScreenshotEntities(in: context)

        let stats = makeUserStats(in: context)
        makeQuest(for: screen, in: context, questEngine: questEngine)
        makeRecentActivity(for: screen, in: context)

        stats.lastDailyGenerationDate = Date()
        stats.lastQuestEngagementDate = Date()

        do {
            try context.save()
        } catch {
            print("❌ AppStoreScreenshotFixtureSeeder: Failed to save fixture data: \(error)")
        }
        #endif
    }

    private static func clearScreenshotEntities(in context: NSManagedObjectContext) {
        ["MediaItem", "ActivityLog", "QuestInstance", "UserStats"].forEach { entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
            } catch {
                print("❌ AppStoreScreenshotFixtureSeeder: Failed to clear \(entityName): \(error)")
            }
        }
    }

    private static func makeUserStats(in context: NSManagedObjectContext) -> UserStats {
        let stats = UserStats(context: context)
        stats.ownerID = AppStoreScreenshotFixtureOwner.ownerID
        stats.totalXP = 1_240
        stats.level = 10
        stats.rank = "E"
        stats.luckXP = 160
        stats.charismaXP = 220
        stats.strengthXP = Int64(AppStoreScreenshotFixtureValues.strengthXP)
        stats.staminaXP = 240
        stats.resilienceXP = 180
        stats.intelligenceXP = 140
        stats.currentStreak = 7
        stats.sideQuestCredits = 3
        stats.dailyProSideQuestRemaining = 0
        return stats
    }

    @discardableResult
    private static func makeQuest(
        for screen: AppStoreScreenshotScreen,
        in context: NSManagedObjectContext,
        questEngine: QuestEngine
    ) -> QuestInstance? {
        switch screen {
        case .questOfTheDay:
            return makeQuest(
                templateID: AppStoreScreenshotFixtureValues.completedQuestID,
                state: "completed",
                assignedOffset: -300,
                context: context,
                questEngine: questEngine
            )
        case .adventureAwaits:
            return makeQuest(
                templateID: AppStoreScreenshotFixtureValues.availableQuestID,
                state: "available",
                assignedOffset: -120,
                context: context,
                questEngine: questEngine
            )
        case .captureMemories, .earnXPLevelUp, .buildYourLore:
            return nil
        }
    }

    private static func makeQuest(
        templateID: String,
        state: String,
        assignedOffset: TimeInterval,
        context: NSManagedObjectContext,
        questEngine: QuestEngine
    ) -> QuestInstance {
        let template = questEngine.getTemplate(id: templateID)
        let quest = QuestInstance(context: context)
        quest.ownerID = AppStoreScreenshotFixtureOwner.ownerID
        quest.id = UUID()
        quest.questTemplateId = templateID
        quest.dateAssigned = Date().addingTimeInterval(assignedOffset)
        quest.state = state
        quest.isSideQuest = false
        quest.generatedTitle = template?.title
        quest.xpReward = Int16(template.map { questEngine.getXP(size: $0.size) } ?? 150)
        quest.primaryStat = template?.primaryStat ?? "stamina"
        quest.secondaryStats = template?.secondaryStats.joined(separator: ",")
        quest.completionTime = state == "completed" ? Date().addingTimeInterval(-60) : nil
        return quest
    }

    private static func makeRecentActivity(for screen: AppStoreScreenshotScreen, in context: NSManagedObjectContext) {
        switch screen {
        case .questOfTheDay:
            makeActivity(note: "Completed a quest", xp: 200, minutesAgo: 4, context: context)
            makeActivity(note: "Streak extended", xp: 25, minutesAgo: 16, context: context)
        case .adventureAwaits:
            makeActivity(note: "Accepted a new daily quest", xp: 0, minutesAgo: 9, context: context)
        case .captureMemories, .earnXPLevelUp, .buildYourLore:
            break
        }
    }

    private static func makeActivity(note: String, xp: Int, minutesAgo: Int, context: NSManagedObjectContext) {
        let activity = ActivityLog(context: context)
        activity.ownerID = AppStoreScreenshotFixtureOwner.ownerID
        activity.id = UUID()
        activity.date = Date().addingTimeInterval(TimeInterval(-minutesAgo * 60))
        activity.note = note
        activity.details = nil
        activity.xpDelta = Int16(xp)
    }
}
