//
//  ActivityDetailHeaderSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct ActivityDetailHeaderSection: View {
    let activityItem: ActivityLogItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activityItem.totalDelta >= 0 ? String(localized: "Total XP Gained") : String(localized: "Total XP Lost"))
                    .font(.subheadline)
                    .foregroundColor(.brandTextSecondary)
                    .textCase(.uppercase)
                
                Text("\(activityItem.totalDelta >= 0 ? "+" : "")\(activityItem.totalDelta) XP")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(activityItem.totalDelta >= 0 ? .brandBrownRich : .red)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(activityDateLabel)
                    .font(.subheadline)
                    .foregroundColor(.brandTextSecondary)
                    .textCase(.uppercase)
                
                if let date = ISO8601DateFormatter().date(from: activityItem.date) {
                    Text(date, style: .date)
                        .font(.headline)
                        .foregroundColor(.brandDarkText)
                    Text(date, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.brandTextSecondary)
                }
            }
        }
        .padding()
        .background(Color.brandCardSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }
    
    private var activityDateLabel: String {
        String(localized: "Completed On")
    }
}
