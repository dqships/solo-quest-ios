//
//  StatDetailRecentActivitySection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatDetailRecentActivitySection: View {
    let statName: String
    let activities: [ActivityLogItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent \(LocalizationService.localizedStatName(statName)) Activity")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
            
            if activities.isEmpty {
                Text("No recent activity for this stat.")
                    .font(.subheadline)
                    .foregroundColor(.brandTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(activities) { item in
                    StatDetailActivityRow(statName: statName, item: item)
                }
            }
        }
    }
}
