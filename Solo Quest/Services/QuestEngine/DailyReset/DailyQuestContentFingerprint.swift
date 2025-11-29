//
//  DailyQuestContentFingerprint.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CryptoKit
import Foundation

enum DailyQuestContentFingerprint {
    static func make(for quest: QuestInstance) -> String {
        let source = [
            quest.questTemplateId ?? "",
            quest.generatedTitle ?? "",
            String(quest.xpReward),
            quest.primaryStat ?? "",
            quest.secondaryStats ?? ""
        ].joined(separator: "|")
        return SHA256.hash(data: Data(source.utf8)).map {
            String(format: "%02x", $0)
        }.joined()
    }
}
