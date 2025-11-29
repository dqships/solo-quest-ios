//
//  QuestEngine+Loading.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

extension QuestEngine {
    func loadGameData() {
        let decoder = JSONDecoder()
        let languageCode = LocalizationService.preferredLanguage

        guard let configURL = Bundle.main.url(forResource: "game_config", withExtension: "json"),
              let configData = try? Data(contentsOf: configURL),
              let config = try? decoder.decode(GameConfig.self, from: configData) else {
            print("❌ QuestEngine: Failed to load game_config.json")
            return
        }

        let questFiles = ["quest_default", "quest_adventure", "quest_dating", "quest_rejection", "quest_friendship", "quest_status", "quest_strength", "quest_stamina", "quest_resilience", "quest_outdoors", "quest_everyday", "quest_general", "quest_general_2", "quest_general_3"]

        var allQuests: [QuestTemplate] = []

        for file in questFiles {
            if let url = Bundle.main.url(forResource: file, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let quests = try? decoder.decode([QuestTemplate].self, from: data) {
                print("✅ QuestEngine: Loaded \(quests.count) quests from \(file).json")
                allQuests.append(contentsOf: quests)
            } else {
                print("⚠️ QuestEngine: Could not load or parse quest file: \(file).json")
            }
        }

        if allQuests.isEmpty {
             print("❌ QuestEngine: Failed to load any quest templates.")
             return
        }

        let topics = loadLocalizedStringArray(baseName: "topics", languageCode: languageCode, decoder: decoder)
        guard !topics.isEmpty else {
            print("❌ QuestEngine: Failed to load topics.json")
            return
        }

        let characters = loadLocalizedStringArray(baseName: "characters", languageCode: languageCode, decoder: decoder)
        guard !characters.isEmpty else {
            print("❌ QuestEngine: Failed to load characters.json")
            return
        }

        self.gameData = GameData(config: config, quests: allQuests, topics: topics, characters: characters)
        print("✅ QuestEngine: Total quest templates loaded: \(self.gameData?.quests.count ?? 0)")
        print("✅ QuestEngine: Loaded \(topics.count) topics and \(characters.count) characters for language: \(languageCode)")
    }

    func loadLocalizedStringArray(baseName: String, languageCode: String, decoder: JSONDecoder) -> [String] {
        let localizedName = "\(baseName)_\(languageCode)"

        if let url = Bundle.main.url(forResource: localizedName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let array = try? decoder.decode([String].self, from: data) {
            print("✅ QuestEngine: Loaded localized \(localizedName).json")
            return array
        }

        if let url = Bundle.main.url(forResource: baseName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let array = try? decoder.decode([String].self, from: data) {
            print("✅ QuestEngine: Loaded fallback \(baseName).json")
            return array
        }

        return []
    }
}
