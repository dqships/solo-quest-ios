//
//  UserStats.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation
import CoreData

@objc(UserStats)
public class UserStats: NSManagedObject, Identifiable {
    @NSManaged public var ownerID: String?
    @NSManaged public var profileID: UUID?
    @NSManaged public var appliedDailyPenaltyXP: Int64

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStats> {
        return NSFetchRequest<UserStats>(entityName: "UserStats")
    }

    @NSManaged public var totalXP: Int64
    @NSManaged public var level: Int16
    @NSManaged public var rank: String?
    @NSManaged public var luckXP: Int64
    @NSManaged public var charismaXP: Int64
    @NSManaged public var strengthXP: Int64
    @NSManaged public var staminaXP: Int64
    @NSManaged public var resilienceXP: Int64
    @NSManaged public var intelligenceXP: Int64
    @NSManaged public var lastDailyGenerationDate: Date?
    @NSManaged public var lastQuestEngagementDate: Date?
    @NSManaged public var currentStreak: Int16
    @NSManaged public var sideQuestCredits: Int16
    @NSManaged public var immunityEndDate: Date?
    @NSManaged public var lastProSideQuestResetDate: Date?
    @NSManaged public var dailyProSideQuestRemaining: Int16
    @NSManaged public var goals: String?
}
