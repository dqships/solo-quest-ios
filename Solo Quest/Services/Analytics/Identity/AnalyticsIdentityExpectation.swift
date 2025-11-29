//
//  AnalyticsIdentityExpectation.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

enum AnalyticsIdentityExpectation: Equatable {
    case linked(clerkUserID: String)
    case unlinked
}
