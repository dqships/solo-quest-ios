//
//  FantasyQuestStatusIndicator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct FantasyQuestStatusIndicator: View {
    let instance: QuestInstance
    
    var body: some View {
        switch instance.state {
        case "locked":
            HStack {
                Image(systemName: "lock.fill")
                if let activation = instance.activationTime {
                    Text("Unlocks in ") + Text(activation, style: .timer)
                } else {
                    Text("Locked")
                }
            }
            .font(.caption)
            .foregroundColor(.brandBrownDeep)
            .padding(6)
            .background(Color.brandBrownHighlight.opacity(0.2))
            .cornerRadius(4)
            
        case "active":
            HStack {
                Image(systemName: "hourglass")
                if let expiry = instance.expiryTime {
                    Text(expiry, style: .timer)
                } else {
                    Text("Active")
                }
            }
            .font(.caption)
            .foregroundColor(.brandAccentOrange)
            .padding(6)
            .background(Color.brandAccentOrange.opacity(0.1))
            .cornerRadius(4)
            
        case "completed":
            Text("QUEST COMPLETED")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.brandBrownRich)
                .padding(6)
                .background(Color.brandBrownRich.opacity(0.1))
                .cornerRadius(4)
            
        case "failed":
            Text("QUEST FAILED")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding(6)
                .background(Color.red.opacity(0.1))
                .cornerRadius(4)
            
        default:
            EmptyView()
        }
    }
}
