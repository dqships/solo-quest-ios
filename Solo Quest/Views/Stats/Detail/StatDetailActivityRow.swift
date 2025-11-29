//
//  StatDetailActivityRow.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatDetailActivityRow: View {
    let statName: String
    let item: ActivityLogItem
    
    var body: some View {
        let statDelta = item.deltaByStat[statName] ?? 0
        
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(statDelta >= 0 ? Color.brandBrownRich : Color.red)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(statDelta >= 0 ? "+\(statDelta) XP" : "\(statDelta) XP")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(statDelta >= 0 ? .brandBrownRich : .red)
                    
                    Text("•")
                        .foregroundColor(.brandTextSecondary)
                    
                    Text(dateFormatter.string(from: ISO8601DateFormatter().date(from: item.date) ?? Date()))
                        .font(.caption)
                        .foregroundColor(.brandTextSecondary)
                }
                
                Text(item.note)
                    .font(.body)
                    .foregroundColor(.brandDarkText)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding()
        .background(Color.brandCardSurface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}
