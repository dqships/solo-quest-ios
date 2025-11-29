//
//  DailyPenaltyMissedGameDayReconciliationTests.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData
import Factory
import XCTest
@testable import Solo_Quest

@MainActor
final class DailyPenaltyMissedGameDayReconciliationTests: XCTestCase {
    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    override func setUp() async throws {
        try await PersistenceController.shared.waitForStoreLoad()
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "ActivityLog", context: context)
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "DailyResetRecord", context: context)
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "QuestInstance", context: context)
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "UserStats", context: context)

        let lifecycleDefaults = UserDefaults(suiteName: "DailyPenaltyMissedGameDayReconciliationTests")!
        lifecycleDefaults.removePersistentDomain(forName: "DailyPenaltyMissedGameDayReconciliationTests")
        let lifecycle = PlayerLifecycleService(defaults: lifecycleDefaults)
        let scopeProvider = AccountScopeProvider()
        scopeProvider.activateTransientScope(ownerID: "clerk:daily-penalty-test")

        Container.shared.playerLifecycleService.register { lifecycle }
        Container.shared.newPlayerProtectionService.register {
            MainActor.assumeIsolated {
                NewPlayerProtectionService(lifecycle: lifecycle)
            }
        }
        Container.shared.accountScopeProvider.register { scopeProvider }
    }

    override func tearDown() async throws {
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "ActivityLog", context: context)
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "DailyResetRecord", context: context)
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "QuestInstance", context: context)
        try CoreDataTestEntityCleaner.deleteAll(entityNamed: "UserStats", context: context)
        Container.shared.playerLifecycleService.reset()
        Container.shared.newPlayerProtectionService.reset()
        Container.shared.accountScopeProvider.reset()
    }

    func testFreeAccountReconcilesEveryMissedGameDay() throws {
        let engine = QuestEngine()
        guard let currentGameDay = engine.gameDayBounds(),
              let threeDaysEarlier = Calendar.current.date(
                byAdding: .day,
                value: -3,
                to: currentGameDay.start
              ) else {
            return XCTFail("Expected valid game-day bounds.")
        }
        let stats = engine.fetchOrCreateUserStats(context: context)
        stats.totalXP = 10_000
        stats.lastDailyGenerationDate = threeDaysEarlier.addingTimeInterval(60)
        let expectedPerDay = engine.dailySkipPenalty(for: [])

        let appliedPenalty = engine.reconcileMissedGameDays(
            context: context,
            userStats: stats,
            currentGameDay: currentGameDay,
            entitlementDecision: .freeVerified
        )

        let request: NSFetchRequest<DailyResetRecord> = DailyResetRecord.fetchRequest()
        request.predicate = NSPredicate(
            format: "ownerID == %@",
            engine.accountScopeProvider.activeScope.ownerID
        )
        let records = try context.fetch(request)
        XCTAssertEqual(records.count, 3)
        XCTAssertTrue(records.allSatisfy {
            $0.outcome == DailyResetOutcomeValue.penalized.rawValue
        })
        XCTAssertTrue(records.allSatisfy { $0.penaltyXP == expectedPerDay })
        XCTAssertEqual(appliedPenalty, Int(expectedPerDay * 3))
        XCTAssertEqual(stats.appliedDailyPenaltyXP, expectedPerDay * 3)
        XCTAssertEqual(stats.totalXP, 10_000 - (expectedPerDay * 3))
    }

    func testProAccountProtectsEveryMissedGameDay() throws {
        let engine = QuestEngine()
        guard let currentGameDay = engine.gameDayBounds(),
              let threeDaysEarlier = Calendar.current.date(
                byAdding: .day,
                value: -3,
                to: currentGameDay.start
              ) else {
            return XCTFail("Expected valid game-day bounds.")
        }
        let stats = engine.fetchOrCreateUserStats(context: context)
        stats.totalXP = 10_000
        stats.lastDailyGenerationDate = threeDaysEarlier.addingTimeInterval(60)

        let appliedPenalty = engine.reconcileMissedGameDays(
            context: context,
            userStats: stats,
            currentGameDay: currentGameDay,
            entitlementDecision: .pro
        )

        let request: NSFetchRequest<DailyResetRecord> = DailyResetRecord.fetchRequest()
        request.predicate = NSPredicate(
            format: "ownerID == %@",
            engine.accountScopeProvider.activeScope.ownerID
        )
        let records = try context.fetch(request)
        XCTAssertEqual(records.count, 3)
        XCTAssertTrue(records.allSatisfy {
            $0.outcome == DailyResetOutcomeValue.protected.rawValue
        })
        XCTAssertTrue(records.allSatisfy { $0.penaltyXP == 0 })
        XCTAssertNil(appliedPenalty)
        XCTAssertEqual(stats.appliedDailyPenaltyXP, 0)
        XCTAssertEqual(stats.totalXP, 10_000)
    }
}
