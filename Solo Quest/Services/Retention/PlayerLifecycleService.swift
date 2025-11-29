//
//  PlayerLifecycleService.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

@MainActor
final class PlayerLifecycleService {
    private enum Key {
        static let usableStartedAt = "SoloQuest.Retention.UsableStartedAt"
        static let firstEvents = "SoloQuest.Retention.FirstEvents"
        static let activeGameDays = "SoloQuest.Retention.ActiveGameDays"
        static let firstCompletionAt = "SoloQuest.Retention.FirstCompletionAt"
        static let rerollsToday = "SoloQuest.Retention.RerollsToday"
        static let rerollsLifetime = "SoloQuest.Retention.RerollsLifetime"
        static let rerollFeedback = "SoloQuest.Retention.RerollFeedback"
        static let rerollFeedbackGameDay = "SoloQuest.Retention.RerollFeedbackGameDay"
        static let earlyJourneyEligible = "SoloQuest.Retention.EarlyJourneyEligible"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var usableStartedAt: Date? {
        defaults.object(forKey: Key.usableStartedAt) as? Date
    }

    var activeDaysLifetime: Int {
        activeGameDays.count
    }

    var rerollsToday: Int {
        let today = RetentionGameDay.identifier()
        guard defaults.string(forKey: "\(Key.rerollsToday).day") == today else { return 0 }
        return defaults.integer(forKey: Key.rerollsToday)
    }

    var rerollsLifetime: Int {
        defaults.integer(forKey: Key.rerollsLifetime)
    }

    var isEarlyJourneyEligible: Bool {
        defaults.bool(forKey: Key.earlyJourneyEligible)
    }

    func beginUsableLifecycleIfNeeded(at date: Date = Date()) {
        guard usableStartedAt == nil else { return }
        defaults.set(date, forKey: Key.usableStartedAt)
        defaults.set(true, forKey: Key.earlyJourneyEligible)
    }

    func migrateCompletedLegacyPlayerIfNeeded() {
        guard usableStartedAt == nil else { return }
        let legacyAnchor = Calendar.current.date(
            byAdding: .day,
            value: -(RetentionFeatureFlags.newPlayerProtectionDurationDays + 1),
            to: Date()
        ) ?? Date.distantPast
        defaults.set(legacyAnchor, forKey: Key.usableStartedAt)
        defaults.set(false, forKey: Key.earlyJourneyEligible)
    }

    func shouldTrackFirstEvent(_ event: String) -> Bool {
        var events = firstEvents
        guard !events.contains(event) else { return false }
        events.insert(event)
        defaults.set(Array(events), forKey: Key.firstEvents)
        return true
    }

    func recordMeaningfulActiveDay(at date: Date = Date()) -> MeaningfulActiveDayMilestone? {
        let identifier = RetentionGameDay.identifier(for: date)
        var days = activeGameDays
        guard !days.contains(identifier) else { return nil }
        days.insert(identifier)
        defaults.set(Array(days), forKey: Key.activeGameDays)

        let activeDay = days.count
        let daysAfterFirstCompletion = firstCompletionAt.flatMap {
            Calendar.current.dateComponents(
                [.day],
                from: RetentionGameDay.start(for: $0),
                to: RetentionGameDay.start(for: date)
            ).day
        }
        return MeaningfulActiveDayMilestone(
            activeDayNumber: activeDay,
            isDayOneReturn: daysAfterFirstCompletion == 1,
            isDaySevenReturn: (daysAfterFirstCompletion ?? -1) >= 7
        )
    }

    func recordFirstCompletion(at date: Date = Date()) {
        if firstCompletionAt == nil {
            defaults.set(date, forKey: Key.firstCompletionAt)
        }
    }

    func recordReroll(reason: RerollReason, at date: Date = Date()) {
        let gameDay = RetentionGameDay.identifier(for: date)
        if defaults.string(forKey: "\(Key.rerollsToday).day") != gameDay {
            defaults.set(gameDay, forKey: "\(Key.rerollsToday).day")
            defaults.set(0, forKey: Key.rerollsToday)
        }
        defaults.set(rerollsToday + 1, forKey: Key.rerollsToday)
        defaults.set(rerollsLifetime + 1, forKey: Key.rerollsLifetime)
        defaults.set(gameDay, forKey: Key.rerollFeedbackGameDay)

        var feedback = Set(defaults.stringArray(forKey: Key.rerollFeedback) ?? [])
        feedback.insert(reason.rawValue)
        defaults.set(Array(feedback), forKey: Key.rerollFeedback)
    }

    func todayRerollFeedback() -> Set<RerollReason> {
        guard defaults.string(forKey: Key.rerollFeedbackGameDay) == RetentionGameDay.identifier() else {
            return []
        }
        return Set((defaults.stringArray(forKey: Key.rerollFeedback) ?? []).compactMap(RerollReason.init(rawValue:)))
    }

    func daysSinceInstall(at date: Date = Date()) -> Int {
        guard let usableStartedAt else { return 0 }
        return max(0, Calendar.current.dateComponents([.day], from: usableStartedAt, to: date).day ?? 0)
    }

    func reset() {
        [Key.usableStartedAt, Key.firstEvents, Key.activeGameDays, Key.firstCompletionAt, Key.rerollsToday, "\(Key.rerollsToday).day", Key.rerollsLifetime, Key.rerollFeedback, Key.rerollFeedbackGameDay, Key.earlyJourneyEligible].forEach {
            defaults.removeObject(forKey: $0)
        }
    }

    private var firstCompletionAt: Date? {
        defaults.object(forKey: Key.firstCompletionAt) as? Date
    }

    private var firstEvents: Set<String> {
        Set(defaults.stringArray(forKey: Key.firstEvents) ?? [])
    }

    private var activeGameDays: Set<String> {
        Set(defaults.stringArray(forKey: Key.activeGameDays) ?? [])
    }

}
