//
//  QuestEngine+QuestSelection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import Factory
import Foundation

extension QuestEngine {
    @discardableResult
    func createRandomQuests(
        context: NSManagedObjectContext,
        count: Int,
        isSideQuest: Bool,
        userLevel: Int,
        excludingTemplateIDs: Set<String> = [],
        dailyGenerationContext: DailyQuestGenerationContext? = nil
    ) -> Int {
        let userStats = fetchOrCreateUserStats(context: context)
        let goalStrings = userStats.goals?.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } ?? []
        let preferredStats = getPreferredStats(from: Set(goalStrings))

        filterPreferences = QuestFilterPreferences.load()

        let isNewPlayer = userStats.totalXP == 0 && isFirstQuestGeneration(context: context)
        let excludedIDs = excludingTemplateIDs.union(
            existingTemplateIDsForCurrentGameDay(context: context, isSideQuest: isSideQuest)
        )
        let selected = selectQuests(
            count: count,
            userLevel: userLevel,
            preferredStats: preferredStats,
            filterPrefs: filterPreferences,
            isNewPlayer: isNewPlayer,
            excludingTemplateIDs: excludedIDs,
            dailyGenerationContext: dailyGenerationContext
        )

        let dailySlots = dailyGenerationContext?.slots.sorted() ?? []
        for (index, template) in selected.enumerated() {
            let slot: Int16?
            if dailyGenerationContext != nil, index < dailySlots.count {
                slot = dailySlots[index]
            } else {
                slot = nil
            }
            createQuestInstance(
                from: template,
                context: context,
                isSideQuest: isSideQuest,
                dailyGenerationContext: dailyGenerationContext,
                dailySlot: slot
            )
        }
        return selected.count
    }

    func getPreferredStats(from goals: Set<String>) -> Set<String> {
        var stats: Set<String> = []
        for goal in goals {
            if let mappedStats = goalStatMapping[goal] {
                stats.formUnion(mappedStats)
            }
        }
        return stats
    }

    func selectQuests(
        count: Int,
        userLevel: Int,
        preferredStats: Set<String> = [],
        filterPrefs: QuestFilterPreferences,
        isNewPlayer: Bool = false,
        excludingTemplateIDs: Set<String> = [],
        rerollFeedbackOverride: Set<RerollReason>? = nil,
        dailyGenerationContext: DailyQuestGenerationContext? = nil
    ) -> [QuestTemplate] {
        guard let data = gameData else { return [] }

        let maxLevel = userLevel + 1
        let levelCandidates = data.quests.filter {
            getEffectiveLevel(for: $0) <= maxLevel && !excludingTemplateIDs.contains($0.id)
        }
        let rerollFeedback = rerollFeedbackOverride ?? Container.shared.playerLifecycleService().todayRerollFeedback()
        var candidates = levelCandidates.filter {
            matchesAllHardPreferences(quest: $0, filterPrefs: filterPrefs) &&
            matchesTodayRerollFeedback(quest: $0, feedback: rerollFeedback)
        }

        // A short, feasible board is better than filling a third card with a quest that
        // silently ignores feasibility constraints. Flexible metadata remains eligible.
        if candidates.isEmpty {
            candidates = levelCandidates.filter { matchesAllHardPreferences(quest: $0, filterPrefs: filterPrefs) }
        }

        if dailyGenerationContext != nil {
            candidates.sort { $0.id < $1.id }
        }

        if candidates.isEmpty {
            print("⚠️ QuestEngine: No quests satisfy the player's hard constraints.")
            return []
        }

        var selected: [QuestTemplate] = []
        var remaining = candidates

        if let dailyGenerationContext {
            let dailySlots = dailyGenerationContext.slots.sorted()
            for dailySlot in dailySlots {
                guard !remaining.isEmpty else { break }

                if isNewPlayer, dailySlot == 0 {
                    let starterCandidates = remaining.filter {
                        isStarterSafeQuest($0) && matchesTodayRerollFeedback(quest: $0, feedback: rerollFeedback)
                    }.sorted { $0.id < $1.id }
                    if let starter = deterministicQuest(
                        candidates: starterCandidates,
                        seed: dailyGenerationContext.seed,
                        purpose: "starter|slot:\(dailySlot)",
                        index: Int(dailySlot)
                    ) {
                        selected.append(starter)
                        remaining.removeAll { $0.id == starter.id }
                        continue
                    }
                }

                guard let selectedQuest = weightedDailyQuest(
                    candidates: remaining,
                    userLevel: userLevel,
                    preferredStats: preferredStats,
                    filterPrefs: filterPrefs,
                    seed: dailyGenerationContext.seed,
                    slot: dailySlot
                ) else {
                    break
                }
                selected.append(selectedQuest)
                remaining.removeAll { $0.id == selectedQuest.id }
            }
            return selected
        }

        if isNewPlayer {
            let starterCandidates = remaining.filter {
                isStarterSafeQuest($0) && matchesTodayRerollFeedback(quest: $0, feedback: rerollFeedback)
            }
            let starter: QuestTemplate?
            if let dailyGenerationContext {
                let orderedStarterCandidates = starterCandidates.sorted { $0.id < $1.id }
                starter = deterministicQuest(
                    candidates: orderedStarterCandidates,
                    seed: dailyGenerationContext.seed,
                    purpose: "starter",
                    index: 0
                )
            } else {
                starter = starterCandidates.randomElement()
            }
            if let starter {
                selected.append(starter)
                remaining.removeAll { $0.id == starter.id }
            }
        }

        if remaining.count + selected.count <= count {
            return selected + remaining
        }

        for _ in selected.count..<count {
            if remaining.isEmpty { break }

            let weightedCandidates = remaining.map { quest in
                (
                    quest: quest,
                    weight: calculateQuestWeight(
                        quest: quest,
                        userLevel: userLevel,
                        preferredStats: preferredStats,
                        filterPrefs: filterPrefs
                    )
                )
            }
            let totalWeight = weightedCandidates.reduce(0.0) { sum, candidate in
                sum + candidate.weight
            }

            guard totalWeight > 0 else { break }
            let fraction = Double.random(in: 0..<1)
            let randomValue = fraction * totalWeight
            var currentWeight = 0.0

            for (index, candidate) in weightedCandidates.enumerated() {
                currentWeight += candidate.weight

                if currentWeight > randomValue {
                    selected.append(candidate.quest)
                    remaining.remove(at: index)
                    break
                }
            }
        }

        return selected
    }

    func matchesPreferredFilters(quest: QuestTemplate, filterPrefs: QuestFilterPreferences) -> Bool {
        guard filterPrefs.hasAnyPreferences else { return true }

        if !filterPrefs.preferredCategories.isEmpty,
           let category = quest.category,
           !filterPrefs.preferredCategories.contains(category) {
            return false
        }

        if !filterPrefs.preferredSocialIntensities.isEmpty,
           let socialIntensity = quest.socialIntensity,
           !filterPrefs.preferredSocialIntensities.contains(socialIntensity) {
            return false
        }

        if !filterPrefs.preferredEnergyLevels.isEmpty,
           let energyLevel = quest.energyLevel,
           !filterPrefs.preferredEnergyLevels.contains(energyLevel) {
            return false
        }

        if !filterPrefs.preferredDurations.isEmpty,
           let duration = quest.duration,
           !filterPrefs.preferredDurations.contains(duration) {
            return false
        }

        if !filterPrefs.preferredLocationTypes.isEmpty,
           let locationType = quest.locationType,
           locationType != .flexible,
           !filterPrefs.preferredLocationTypes.contains(locationType) {
            return false
        }

        if !filterPrefs.preferredCostLevels.isEmpty,
           let costLevel = quest.costLevel,
           !filterPrefs.preferredCostLevels.contains(costLevel) {
            return false
        }

        if !filterPrefs.preferredTimeOfDay.isEmpty,
           let timeOfDay = quest.timeOfDay,
           timeOfDay != .any,
           !filterPrefs.preferredTimeOfDay.contains(.any),
           !filterPrefs.preferredTimeOfDay.contains(timeOfDay) {
            return false
        }

        if !filterPrefs.preferredComfortZones.isEmpty,
           let comfortZone = quest.comfortZone,
           !filterPrefs.preferredComfortZones.contains(comfortZone) {
            return false
        }

        return true
    }

    func calculateQuestWeight(quest: QuestTemplate, userLevel: Int, preferredStats: Set<String>, filterPrefs: QuestFilterPreferences) -> Double {
        let level = getEffectiveLevel(for: quest)
        var weight = (level == userLevel) ? 10.0 : 1.0

        if !preferredStats.isEmpty {
            let questPrimaryStat = quest.primaryStat.lowercased()
            let questSecondaryStats = Set(quest.secondaryStats.map { $0.lowercased() })

            if preferredStats.contains(questPrimaryStat) {
                weight *= 3
            }

            if !preferredStats.isDisjoint(with: questSecondaryStats) {
                weight *= 1.5
            }
        }

        if filterPrefs.hasAnyPreferences {
            var filterBoost: Double = 1.0

            if !filterPrefs.preferredCategories.isEmpty {
                if let cat = quest.category, filterPrefs.preferredCategories.contains(cat) {
                    filterBoost *= 2.0
                }
            }

            if !filterPrefs.preferredSocialIntensities.isEmpty {
                if let si = quest.socialIntensity, filterPrefs.preferredSocialIntensities.contains(si) {
                    filterBoost *= 2.0
                }
            }

            if !filterPrefs.preferredEnergyLevels.isEmpty {
                if let el = quest.energyLevel, filterPrefs.preferredEnergyLevels.contains(el) {
                    filterBoost *= 2.0
                }
            }

            if !filterPrefs.preferredDurations.isEmpty {
                if let d = quest.duration, filterPrefs.preferredDurations.contains(d) {
                    filterBoost *= 2.0
                }
            }

            if !filterPrefs.preferredLocationTypes.isEmpty {
                if let loc = quest.locationType, filterPrefs.preferredLocationTypes.contains(loc) {
                    filterBoost *= 2.0
                }
            }

            if !filterPrefs.preferredCostLevels.isEmpty {
                if let cl = quest.costLevel, filterPrefs.preferredCostLevels.contains(cl) {
                    filterBoost *= 2.0
                }
            }

            if !filterPrefs.preferredTimeOfDay.isEmpty {
                if let tod = quest.timeOfDay, filterPrefs.preferredTimeOfDay.contains(tod) {
                    filterBoost *= 1.5
                }
            }

            if !filterPrefs.preferredComfortZones.isEmpty {
                if let cz = quest.comfortZone, filterPrefs.preferredComfortZones.contains(cz) {
                    filterBoost *= 2.0
                }
            }

            weight *= filterBoost
        }

        return max(weight, 1.0)
    }

    func getEffectiveLevel(for template: QuestTemplate) -> Int {
        if let level = template.level {
            return level
        }

        switch template.size {
        case "micro": return 1
        case "small": return 5
        case "medium": return 15
        case "big": return 30
        case "massive": return 50
        default: return 1
        }
    }

    func createQuestInstance(
        from template: QuestTemplate,
        context: NSManagedObjectContext,
        isSideQuest: Bool,
        dailyGenerationContext: DailyQuestGenerationContext? = nil,
        dailySlot: Int16? = nil
    ) {
        let instance = QuestInstance(context: context)
        instance.ownerID = accountScopeProvider.activeScope.ownerID
        instance.id = UUID()
        instance.questTemplateId = template.id
        instance.generatedTitle = fillSlots(
            template: template,
            gameData: gameData,
            dailyGenerationContext: dailyGenerationContext,
            dailySlot: dailySlot
        )
        instance.state = "available"
        instance.dateAssigned = dailyGenerationContext?.gameDayStart ?? Date()
        instance.isSideQuest = isSideQuest
        instance.primaryStat = template.primaryStat
        instance.secondaryStats = template.secondaryStats.joined(separator: ",")

        let size = template.size
        let baseXP = self.gameData?.config.questSizes[size] ?? 100
        instance.xpReward = Int16(baseXP)

        if let dailyGenerationContext, let dailySlot {
            instance.gameDayID = dailyGenerationContext.gameDayID
            instance.dailySlot = dailySlot
            instance.logicalID = DailyQuestLogicalIdentifier.make(
                ownerID: accountScopeProvider.activeScope.writeOwnerID,
                gameDayID: dailyGenerationContext.gameDayID,
                slot: dailySlot,
                algorithmVersion: DailyResetAlgorithmVersion.value
            )
        }
    }

    func fillSlots(
        template: QuestTemplate,
        gameData: GameData?,
        dailyGenerationContext: DailyQuestGenerationContext? = nil,
        dailySlot: Int16? = nil
    ) -> String {
        guard let data = gameData else { return template.localizedTemplate }

        var text = template.localizedTemplate

        for (index, slotType) in template.slots.enumerated() {
            if let range = text.range(of: "\\[.*?\\]", options: .regularExpression) {
                let replacement: String

                switch slotType {
                case "topic":
                    replacement = dailySlotReplacement(
                        values: data.topics,
                        fallback: "life",
                        dailyGenerationContext: dailyGenerationContext,
                        dailySlot: dailySlot,
                        purpose: "topic",
                        index: index
                    )
                case "person", "personType":
                    replacement = dailySlotReplacement(
                        values: data.characters,
                        fallback: "a friend",
                        dailyGenerationContext: dailyGenerationContext,
                        dailySlot: dailySlot,
                        purpose: "person",
                        index: index
                    )
                default:
                    replacement = "something"
                }

                text.replaceSubrange(range, with: replacement)
            }
        }

        return text
    }

    private func deterministicQuest(
        candidates: [QuestTemplate],
        seed: String,
        purpose: String,
        index: Int
    ) -> QuestTemplate? {
        guard !candidates.isEmpty else { return nil }
        let fraction = DeterministicRandomFraction.make(seed: seed, purpose: purpose, index: index)
        let candidateIndex = min(Int(fraction * Double(candidates.count)), candidates.count - 1)
        return candidates[candidateIndex]
    }

    private func weightedDailyQuest(
        candidates: [QuestTemplate],
        userLevel: Int,
        preferredStats: Set<String>,
        filterPrefs: QuestFilterPreferences,
        seed: String,
        slot: Int16
    ) -> QuestTemplate? {
        let weightedCandidates = candidates.map { quest in
            (
                quest: quest,
                weight: calculateQuestWeight(
                    quest: quest,
                    userLevel: userLevel,
                    preferredStats: preferredStats,
                    filterPrefs: filterPrefs
                )
            )
        }
        let totalWeight = weightedCandidates.reduce(0.0) { partialResult, candidate in
            partialResult + candidate.weight
        }
        guard totalWeight > 0 else { return nil }

        let fraction = DeterministicRandomFraction.make(
            seed: seed,
            purpose: "weighted_draw|slot:\(slot)",
            index: Int(slot)
        )
        let randomValue = fraction * totalWeight
        var currentWeight = 0.0

        for candidate in weightedCandidates {
            currentWeight += candidate.weight
            if currentWeight > randomValue {
                return candidate.quest
            }
        }

        return weightedCandidates.last?.quest
    }

    private func dailySlotReplacement(
        values: [String],
        fallback: String,
        dailyGenerationContext: DailyQuestGenerationContext?,
        dailySlot: Int16?,
        purpose: String,
        index: Int
    ) -> String {
        guard let dailyGenerationContext, let dailySlot else {
            return values.randomElement() ?? fallback
        }
        let orderedValues = values.sorted()
        guard !orderedValues.isEmpty else { return fallback }
        let fraction = DeterministicRandomFraction.make(
            seed: dailyGenerationContext.seed,
            purpose: "\(purpose)|slot:\(dailySlot)|replacement:\(index)",
            index: Int(dailySlot)
        )
        let valueIndex = min(Int(fraction * Double(orderedValues.count)), orderedValues.count - 1)
        return orderedValues[valueIndex]
    }
}
