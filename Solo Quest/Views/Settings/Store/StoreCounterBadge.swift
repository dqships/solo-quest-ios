//
//  StoreCounterBadge.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StoreCounterBadge: View {
    let icon: String
    let text: String
    let background: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.brandBrownRich)
            
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.brandBrownRich)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(background)
        .cornerRadius(12)
    }
}
