//
//  MyGoalRow.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct MyGoalRow: View {
    let goal: String
    let isSelected: Bool
    let toggle: () -> Void
    
    var body: some View {
        Button(action: toggle) {
            HStack {
                GoalIconView(goal: goal)
                    .font(.title2)
                    .foregroundColor(isSelected ? .brandBrownRich : .brandTextSecondary)
                    .frame(width: 32)
                
                Text(LocalizationService.localizedGoalName(goal))
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.brandDarkText)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .brandBrownRich : .brandDarkText.opacity(0.3))
            }
            .padding()
            .background(Color.brandCardSurface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.brandBrownRich : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
