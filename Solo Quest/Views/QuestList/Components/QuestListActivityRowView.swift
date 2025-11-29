//
//  QuestListActivityRowView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestListActivityRowView: View {
    let item: ActivityLogItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(item.totalDelta >= 0 ? Color.brandBrownRich : Color.red)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.totalDelta >= 0 ? "+\(item.totalDelta) XP" : "\(item.totalDelta) XP")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(item.totalDelta >= 0 ? .brandBrownRich : .red)
                    
                    Text("•")
                        .foregroundColor(.brandTextSecondary)
                    
                    Text(dateFormatter.string(from: ISO8601DateFormatter().date(from: item.date) ?? Date()))
                        .font(.caption)
                        .foregroundColor(.brandTextSecondary)
                }
                
                Text(item.localizedNote)
                    .font(.body)
                    .foregroundColor(.brandDarkText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                if !item.deltaByStat.isEmpty {
                    HStack {
                        ForEach(item.deltaByStat.keys.sorted(), id: \.self) { stat in
                            let val = item.deltaByStat[stat] ?? 0
                            Text("\(stat.capitalized) \(val > 0 ? "+" : "")\(val)")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.brandNeutral.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.brandTextSecondary)
                .padding(.top, 4)
        }
        .padding()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}
