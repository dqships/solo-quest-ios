//
//  ClerkUserAnalyticsProfileFactory.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Clerk
import Foundation

enum ClerkUserAnalyticsProfileFactory {
    static func make(from user: User) -> ClerkUserAnalyticsProfile {
        let email = user.primaryEmailAddress?.emailAddress
        let providers = Array(Set(user.externalAccounts.map(\.provider))).sorted()
        let primaryProvider = user.verifiedExternalAccounts.first?.provider
            ?? providers.first
            ?? (user.passwordEnabled ? "password" : "unknown")

        return ClerkUserAnalyticsProfile(
            clerkUserId: user.id,
            emailAddress: email,
            emailDomain: EmailAnalyticsClassifier.domain(from: email),
            emailType: EmailAnalyticsClassifier.classify(email),
            displayName: displayName(for: user),
            firstNamePresent: user.firstName?.isEmpty == false,
            lastNamePresent: user.lastName?.isEmpty == false,
            phonePresent: !user.phoneNumbers.isEmpty,
            hasVerifiedEmail: user.hasVerifiedEmailAddress,
            passwordEnabled: user.passwordEnabled,
            totpEnabled: user.totpEnabled,
            authProviders: providers,
            primaryAuthProvider: primaryProvider,
            createdAt: user.createdAt,
            lastSignInAt: user.lastSignInAt
        )
    }

    private static func displayName(for user: User) -> String? {
        let names: [String] = [user.firstName, user.lastName].compactMap { value -> String? in
            guard let value, !value.isEmpty else { return nil }
            return value
        }

        if !names.isEmpty {
            return names.joined(separator: " ")
        }

        return nil
    }
}
