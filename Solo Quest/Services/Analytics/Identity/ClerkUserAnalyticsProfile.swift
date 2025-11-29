//
//  ClerkUserAnalyticsProfile.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation

struct ClerkUserAnalyticsProfile {
    let clerkUserId: String
    let emailAddress: String?
    let emailDomain: String?
    let emailType: EmailAnalyticsType
    let displayName: String?
    let firstNamePresent: Bool
    let lastNamePresent: Bool
    let phonePresent: Bool
    let hasVerifiedEmail: Bool
    let passwordEnabled: Bool
    let totpEnabled: Bool
    let authProviders: [String]
    let primaryAuthProvider: String
    let createdAt: Date
    let lastSignInAt: Date?

    var postHogUserProperties: [String: Any] {
        [
            "clerk_user_id": clerkUserId,
            "revenuecat_app_user_id": clerkUserId,
            "email_domain": emailDomain ?? "missing",
            "email_type": emailType.rawValue,
            "auth_providers": authProviders,
            "primary_auth_provider": primaryAuthProvider,
            "first_name_present": firstNamePresent,
            "last_name_present": lastNamePresent,
            "phone_present": phonePresent,
            "email_verified": hasVerifiedEmail,
            "password_enabled": passwordEnabled,
            "totp_enabled": totpEnabled,
            "clerk_created_at": AnalyticsDateFormatter.string(from: createdAt),
            "clerk_last_sign_in_at": lastSignInAt.map(AnalyticsDateFormatter.string(from:)) ?? "missing"
        ]
    }

    var revenueCatAttributes: [String: String] {
        [
            "clerk_user_id": clerkUserId,
            "posthog_distinct_id": clerkUserId,
            "email_domain": emailDomain ?? "missing",
            "email_type": emailType.rawValue,
            "auth_providers": authProviders.joined(separator: ","),
            "primary_auth_provider": primaryAuthProvider,
            "clerk_created_at": AnalyticsDateFormatter.string(from: createdAt)
        ]
    }
}
