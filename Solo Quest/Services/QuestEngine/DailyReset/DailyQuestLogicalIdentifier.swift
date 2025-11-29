//
//  DailyQuestLogicalIdentifier.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CryptoKit
import Foundation

enum DailyQuestLogicalIdentifier {
    static func make(
        ownerID: String,
        gameDayID: String,
        slot: Int16,
        algorithmVersion: Int16
    ) -> String {
        let source = "\(ownerID)|\(gameDayID)|\(slot)|\(algorithmVersion)"
        return SHA256.hash(data: Data(source.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}
