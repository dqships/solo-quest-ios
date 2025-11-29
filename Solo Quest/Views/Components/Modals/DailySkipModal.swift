//
//  DailySkipModal.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct DailySkipModal: View {
    let penaltyXP: Int
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Circle()
                .fill(Color.brandNeutral.opacity(0.2))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 28))
                        .foregroundColor(.brandDarkText)
                )
            
            // Title
            Text("You missed yesterday")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
            
            // Body
            VStack(spacing: 8) {
                Text("You didn’t attempt any of your quests yesterday.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.brandTextSecondary)
                
                Text("Penalty: −\(penaltyXP) XP total")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("(-100 Charisma, -75 Resilience, -50 Luck)") // Mock breakdown
                    .font(.caption)
                    .foregroundColor(.brandTextSecondary)
            }
            
            // Recovery Note
            Text("You can still climb back up. One quest today moves you forward again.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.brandBrownMid)
                .padding(.top, 8)
            
            // Button
            Button(action: onDismiss) {
                Text("Show Today’s Quests")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandBrownRich)
                    .cornerRadius(12)
            }
            .padding(.top, 16)
        }
    }
}

