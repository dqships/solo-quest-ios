//
//  AppearanceManager.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 12-06-2025
//

import SwiftUI
import Combine

@MainActor
class AppearanceManager: ObservableObject {
    static let shared = AppearanceManager()
    
    private let isDarkModeKey = "isDarkModeEnabled"
    
    @Published var isDarkModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isDarkModeEnabled, forKey: isDarkModeKey)
        }
    }
    
    var colorScheme: ColorScheme {
        isDarkModeEnabled ? .dark : .light
    }
    
    private init() {
        self.isDarkModeEnabled = UserDefaults.standard.bool(forKey: isDarkModeKey)
    }
}

