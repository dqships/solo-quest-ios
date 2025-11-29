//
//  AnalyticsIdentityStorage.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import Foundation

enum AnalyticsIdentityStorage {
    private static let linkedClerkUserIdKey = "SoloQuest.Analytics.LinkedClerkUserId"

    static var linkedClerkUserId: String? {
        get {
            UserDefaults.standard.string(forKey: linkedClerkUserIdKey)
        }
        set {
            if let newValue {
                UserDefaults.standard.set(newValue, forKey: linkedClerkUserIdKey)
            } else {
                UserDefaults.standard.removeObject(forKey: linkedClerkUserIdKey)
            }
        }
    }
}
