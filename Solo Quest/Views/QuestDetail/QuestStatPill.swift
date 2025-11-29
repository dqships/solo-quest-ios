//
//  QuestStatPill.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestStatPill: View {
    let title: LocalizedStringKey
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.brandTextSecondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.brandDarkText)
            }
            Spacer()
        }
        .padding()
        .background(Color.brandCardSurface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }
}
