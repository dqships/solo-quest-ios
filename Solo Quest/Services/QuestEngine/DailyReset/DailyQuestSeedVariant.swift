//
//  DailyQuestSeedVariant.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CryptoKit
import Foundation

enum DailyQuestSeedVariant {
    static func make(baseSeed: String, variant: String) -> String {
        let source = "\(baseSeed)|\(variant)"
        return SHA256.hash(data: Data(source.utf8)).map {
            String(format: "%02x", $0)
        }.joined()
    }
}
