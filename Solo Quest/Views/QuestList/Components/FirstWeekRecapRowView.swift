//
//  FirstWeekRecapRowView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import SwiftUI

struct FirstWeekRecapRowView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color.brandTextSecondary)
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(Color.brandDarkText)
        }
        .accessibilityElement(children: .combine)
    }
}
