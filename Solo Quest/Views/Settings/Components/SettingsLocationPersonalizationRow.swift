//
//  SettingsLocationPersonalizationRow.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import SwiftUI

struct SettingsLocationPersonalizationRow: View {
    let statusTitle: String
    let actionTitle: String
    let isRequesting: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "location.fill")
                .foregroundColor(.brandTextSecondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text("Location Personalization")
                    .foregroundColor(.brandDarkText)

                Text(statusTitle)
                    .font(.caption)
                    .foregroundColor(.brandTextSecondary)
            }

            Spacer()

            Button(action: action) {
                HStack(spacing: 6) {
                    if isRequesting {
                        ProgressView()
                            .scaleEffect(0.7)
                    }

                    Text(actionTitle)
                        .font(.caption.weight(.semibold))
                }
                .foregroundColor(.brandBrownRich)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.brandBrownRich.opacity(0.12))
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .disabled(isRequesting || actionTitle == String(localized: "Enabled"))
        }
        .padding(.vertical, 2)
    }
}
