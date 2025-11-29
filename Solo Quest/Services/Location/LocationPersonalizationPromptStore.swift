//
//  LocationPersonalizationPromptStore.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import Foundation

enum LocationPersonalizationPromptStore {
    private static let hasSeenPromptKey = "SoloQuest.HasSeenLocationPersonalizationPrompt"

    static var hasSeenPrompt: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasSeenPromptKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasSeenPromptKey)
        }
    }
}
