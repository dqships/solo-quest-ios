//
//  NavigationDestination.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case rankProgress(rank: String, level: Int)
    case statDetail(statName: String, currentXP: Int, tagline: String)
    case questDetail(instance: QuestInstance, template: QuestTemplate?)
    case adventureMediaFeed(initialItem: MediaItem) // Pass minimal info? MediaItem is Hashable.
    case activityDetail(item: ActivityLogItem)
}

