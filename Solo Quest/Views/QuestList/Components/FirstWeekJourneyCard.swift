//
//  FirstWeekJourneyCard.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Factory
import SwiftUI

struct FirstWeekJourneyCard: View {
    @Injected(\.playerLifecycleService) private var lifecycle
    @Injected(\.firstWeekRecapService) private var recapService
    let user: UserProfile?
    @State private var recap: FirstWeekRecap?

    var body: some View {
        Group {
            if lifecycle.isEarlyJourneyEligible && lifecycle.activeDaysLifetime > 0 && lifecycle.activeDaysLifetime <= 7 {
                let stage = FirstWeekJourneyStage(activeDay: lifecycle.activeDaysLifetime)
                VStack(alignment: .leading, spacing: 8) {
                    Text(stage.title)
                        .font(.headline)
                        .foregroundStyle(Color.brandDarkText)
                    Text(stage.message)
                        .font(.subheadline)
                        .foregroundStyle(Color.brandTextSecondary)
                    if lifecycle.activeDaysLifetime == 3, let user {
                        Text("\(user.strongestStatName) is leading your character growth.")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.brandBrownRich)
                    }
                    if lifecycle.activeDaysLifetime >= 6 {
                        Button(
                            lifecycle.activeDaysLifetime == 7
                                ? String(localized: "View Your First Chapter")
                                : String(localized: "See your progress")
                        ) {
                            recap = recapService.makeRecap()
                        }
                        .buttonStyle(.bordered)
                        .tint(.brandBrownRich)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $recap) { FirstWeekRecapView(recap: $0) }
    }

}
