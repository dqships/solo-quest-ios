//
//  QuestCardStateContent.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestCardStateContent: View {
    let instance: QuestInstance
    
    var body: some View {
        switch instance.state {
        case "available":
            Text("You haven't started this quest yet.")
                .font(.subheadline)
                .foregroundColor(.brandTextSecondary)
            
        case "locked":
            VStack(alignment: .leading, spacing: 4) {
                Text("Quest in progress")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandBrownRich)
                if let activation = instance.activationTime {
                    HStack(spacing: 4) {
                        Text("Completion unlocks in")
                        Text(activation, style: .timer)
                            .monospacedDigit()
                    }
                    .font(.caption)
                    .foregroundColor(.brandBrownDeep)
                } else {
                    Text("Completion locked")
                        .font(.caption)
                        .foregroundColor(.brandBrownDeep)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.brandBrownHighlight.opacity(0.1))
            .cornerRadius(6)
            
        case "active":
            VStack(alignment: .leading, spacing: 4) {
                Text("Quest active")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandAccentOrange)
                if let expiry = instance.expiryTime {
                    HStack(spacing: 4) {
                        Text("Time left:")
                        Text(expiry, style: .timer)
                            .monospacedDigit()
                    }
                    .font(.caption)
                    .foregroundColor(.brandBrownDeep)
                }
            }
            
        case "completed":
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.brandBrownRich)
                Text("Nice work. This quest boosted your stats.")
                    .font(.caption)
                    .foregroundColor(.brandTextSecondary)
            }
            
        case "failed":
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text("Time's up. Penalty applied.")
                    .font(.caption)
                    .foregroundColor(.brandTextSecondary)
            }
            
        default:
            EmptyView()
        }
    }
}
