//
//  QuestRankResolver.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum QuestRankResolver {
    static func rank(for template: QuestTemplate?, instance: QuestInstance) -> String {
        guard let size = template?.size.lowercased() else { return "E" }
        
        switch size {
        case "micro":
            return "E"
        case "small":
            return "D"
        case "medium":
            return "C"
        case "big":
            return "B"
        case "massive":
            if let uuid = instance.id?.uuidString.last,
               let hexValue = Int(String(uuid), radix: 16) {
                return hexValue < 4 ? "S" : "A"
            }
            return "A"
        default:
            return "E"
        }
    }
}
