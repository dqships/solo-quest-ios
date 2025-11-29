//
//  AnalyticsManager.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 12-04-2025.
//

import Foundation
import PostHog

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}
    
    // MARK: - Generic Event Tracking
    
    func track(event: String, properties: [String: Any]? = nil) {
        PostHogSDK.shared.capture(event, properties: properties)
    }
    
    // MARK: - User Identification
    
    func identify(userId: String, userProperties: [String: Any]? = nil) {
        PostHogSDK.shared.identify(userId, userProperties: userProperties)
    }
    
    func reset() {
        PostHogSDK.shared.reset()
    }
    
    // MARK: - Core Events Helper Methods
    
    func trackAppOpened(fromBackground: Bool = false) {
        track(event: "app_opened", properties: ["from_background": fromBackground])
    }
    
    func trackOnboardingStarted() {
        track(event: "onboarding_started")
    }
    
    func trackOnboardingStepCompleted(step: String) {
        track(event: "onboarding_step_completed", properties: ["step": step])
    }
    
    func trackOnboardingCompleted() {
        track(event: "onboarding_completed")
    }
    
    func trackQuestGenerated(count: Int) {
        track(event: "quest_generated", properties: ["quest_count": count])
    }
    
    func trackQuestStarted(id: String, category: String, difficulty: String) {
        track(event: "quest_started", properties: [
            "quest_id": id,
            "category": category,
            "difficulty": difficulty
        ])
    }
    
    func trackQuestCompleted(id: String, xp: Int64, stats: [String: Double]) {
        track(event: "quest_completed", properties: [
            "quest_id": id,
            "xp_earned": Int(xp),
            "stats_gained": stats
        ])
    }
    
    func trackQuestFailed(id: String) {
        track(event: "quest_failed", properties: ["quest_id": id])
    }
    
    func trackLevelUp(newLevel: Int16, totalXP: Int64) {
        track(event: "level_up", properties: [
            "new_level": Int(newLevel),
            "total_xp": Int(totalXP)
        ])
    }
    
    func trackRankUp(newRank: String) {
        track(event: "rank_up", properties: ["new_rank": newRank])
    }
    
    func trackStoreViewed() {
        track(event: "store_viewed")
    }
    
    func trackStoreProductSelected(id: String, name: String, type: String) {
        track(event: "store_product_selected", properties: [
            "product_id": id,
            "product_name": name,
            "product_type": type
        ])
    }
    
    func trackPurchaseCompleted(id: String, name: String, type: String, price: String) {
        track(event: "purchase_completed", properties: [
            "product_id": id,
            "product_name": name,
            "product_type": type,
            "price": price
        ])
    }
    
    func trackSubscriptionStarted(productId: String, price: Double) {
        track(event: "subscription_started", properties: [
            "product_id": productId,
            "price": price
        ])
    }
    
    func trackMediaCaptured(type: String, questId: String?) {
        track(event: "media_captured", properties: [
            "media_type": type,
            "quest_id": questId ?? "none"
        ])
    }
    
    func trackMediaViewed(id: String, context: String) {
        track(event: "media_viewed", properties: [
            "media_id": id,
            "context": context
        ])
    }
    
    func trackMediaShared(id: String) {
        track(event: "media_shared", properties: ["media_id": id])
    }
    
    func trackTabChanged(tabName: String) {
        track(event: "tab_changed", properties: ["tab_name": tabName])
    }
}
