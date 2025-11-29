//
//  ClerkConfiguration.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11-03-2026
//

import Clerk
import Foundation

/// Sign-in is only offered or required when a Clerk publishable key is configured.
enum ClerkConfiguration {
    static var isEnabled: Bool {
        ConfiguredInfoValue.string(forKey: "ClerkPublishableKey") != nil
    }

    /// True when Clerk is set up and nobody is signed in.
    @MainActor
    static func requiresSignIn(user: User?) -> Bool {
        isEnabled && user == nil
    }
}
