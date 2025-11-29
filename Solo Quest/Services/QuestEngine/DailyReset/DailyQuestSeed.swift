//
//  DailyQuestSeed.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CryptoKit
import Foundation

enum DailyQuestSeed {
    static func make(ownerID: String, gameDayID: String, algorithmVersion: Int16) -> String {
        let source = "\(ownerID)|\(gameDayID)|\(algorithmVersion)"
        return SHA256.hash(data: Data(source.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}
