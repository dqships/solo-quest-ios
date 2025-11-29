//
//  SoloQuestClerkLoader.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Modified by DaQuan Louden on 11-03-2026
//

import Clerk
import Foundation

enum SoloQuestClerkLoader {
    static func load(_ clerk: Clerk) async {
        guard let publishableKey = ConfiguredInfoValue.string(forKey: "ClerkPublishableKey") else { return }

        clerk.configure(publishableKey: publishableKey)
        try? await clerk.load()
    }
}
