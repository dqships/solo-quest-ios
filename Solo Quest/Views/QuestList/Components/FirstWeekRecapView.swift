//
//  FirstWeekRecapView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import SwiftUI

struct FirstWeekRecapView: View {
    @Environment(\.dismiss) private var dismiss
    let recap: FirstWeekRecap

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your First Chapter")
                    .font(.largeTitle.bold())
                Text("You built this chapter through real action. Every win counts.")
                    .foregroundStyle(Color.brandTextSecondary)

                FirstWeekRecapRowView(title: String(localized: "Quests completed"), value: "\(recap.questsCompleted)")
                FirstWeekRecapRowView(title: String(localized: "Active days"), value: "\(recap.activeDays)")
                FirstWeekRecapRowView(title: String(localized: "XP earned"), value: "+\(recap.xpEarned)")
                FirstWeekRecapRowView(title: String(localized: "Strongest stat"), value: "\(recap.strongestStat) · \(recap.strongestStatXP) XP")
                FirstWeekRecapRowView(
                    title: String(localized: "Character"),
                    value: String(
                        format: String(localized: "Level %lld · Rank %@"),
                        recap.level,
                        recap.rank
                    )
                )
                FirstWeekRecapRowView(title: String(localized: "Adventure Log memories"), value: "\(recap.memoriesCreated)")

                Button("Done") { dismiss() }
                    .buttonStyle(.borderedProminent)
                    .tint(.brandBrownRich)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(28)
        }
        .background(Color.brandBackground)
        .accessibilityElement(children: .contain)
    }

}
