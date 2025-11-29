//
//  ActivityDetailQuestStatsSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct ActivityDetailQuestStatsSection: View {
    let quest: QuestInstance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Attributes")
                .font(.headline)
                .foregroundColor(.brandDarkText)
            
            HStack(spacing: 12) {
                if let primary = quest.primaryStat {
                    ActivityDetailStatBadge(name: primary, isPrimary: true)
                }
                
                ForEach(quest.secondaryStatsArray, id: \.self) { stat in
                    ActivityDetailStatBadge(name: stat, isPrimary: false)
                }
            }
        }
    }
}
