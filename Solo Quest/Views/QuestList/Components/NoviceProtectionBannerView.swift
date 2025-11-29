//
//  NoviceProtectionBannerView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import SwiftUI

struct NoviceProtectionBannerView: View {
    let daysRemaining: Int

    var body: some View {
        let dayUnit = daysRemaining == 1 ? String(localized: "day") : String(localized: "days")

        VStack(alignment: .leading, spacing: 5) {
            Text("Novice Protection")
                .font(.headline)
                .foregroundStyle(Color.brandBrownRich)
            Text("Learn the rhythm without losing XP. \(daysRemaining) protected \(dayUnit) remaining.")
                .font(.subheadline)
                .foregroundStyle(Color.brandTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }
}
