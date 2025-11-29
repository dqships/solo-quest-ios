//
//  FilterChipView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct FilterChipView<T>: View {
    let item: T
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.system(size: 12, weight: .semibold))
                
                Text(displayName)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                isSelected
                    ? Color.brandBrownRich.opacity(0.15)
                    : Color.brandCardSurface
            )
            .foregroundColor(
                isSelected ? .brandBrownRich : .brandDarkText.opacity(0.7)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.brandBrownRich : Color.brandDarkText.opacity(0.12),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
    }
    
    private var displayName: String {
        if let cat = item as? QuestCategory { return cat.displayName }
        if let si = item as? SocialIntensity { return si.displayName }
        if let el = item as? EnergyLevel { return el.displayName }
        if let db = item as? DurationBucket { return db.displayName }
        if let lt = item as? LocationType { return lt.displayName }
        if let cl = item as? CostLevel { return cl.displayName }
        if let tod = item as? TimeOfDay { return tod.displayName }
        if let cz = item as? ComfortZone { return cz.displayName }
        return ""
    }
    
    private var iconName: String {
        if let cat = item as? QuestCategory { return cat.icon }
        if let si = item as? SocialIntensity { return si.icon }
        if let el = item as? EnergyLevel { return el.icon }
        if let db = item as? DurationBucket { return db.icon }
        if let lt = item as? LocationType { return lt.icon }
        if let cl = item as? CostLevel { return cl.icon }
        if let tod = item as? TimeOfDay { return tod.icon }
        if let cz = item as? ComfortZone { return cz.icon }
        return "circle"
    }
}
