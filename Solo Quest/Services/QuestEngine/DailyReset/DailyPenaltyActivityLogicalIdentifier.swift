//
//  DailyPenaltyActivityLogicalIdentifier.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CryptoKit
import Foundation

enum DailyPenaltyActivityLogicalIdentifier {
    static func make(resetLogicalID: String) -> String {
        let source = "daily-penalty|\(resetLogicalID)"
        return SHA256.hash(data: Data(source.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}
