//
//  EmailAnalyticsClassifier.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-04-2026
//

import Foundation

enum EmailAnalyticsClassifier {
    static func domain(from email: String?) -> String? {
        guard let email else { return nil }
        let parts = email.lowercased().split(separator: "@", maxSplits: 1)
        guard parts.count == 2 else { return nil }
        return String(parts[1])
    }

    static func classify(_ email: String?) -> EmailAnalyticsType {
        guard let domain = domain(from: email) else { return .missing }

        switch domain {
        case "privaterelay.appleid.com":
            return .applePrivateRelay
        case "gmail.com", "googlemail.com":
            return .gmail
        case "icloud.com", "me.com", "mac.com":
            return .appleMail
        default:
            return .other
        }
    }
}
