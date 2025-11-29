//
//  ActivityDetailStatBadge.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct ActivityDetailStatBadge: View {
    let name: String
    let isPrimary: Bool
    
    var body: some View {
        Text(LocalizationService.localizedStatName(name))
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isPrimary ? Color.brandBrownRich.opacity(0.15) : Color.brandNeutral.opacity(0.15))
            .foregroundColor(isPrimary ? .brandBrownRich : .brandTextSecondary)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isPrimary ? Color.brandBrownRich.opacity(0.3) : Color.clear, lineWidth: 1)
            )
    }
}
