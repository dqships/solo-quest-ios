//
//  QuestFailureModal.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct QuestFailureModal: View {
    let reason: FailReason
    let penaltyXP: Int
    let onDismiss: () -> Void
    
    enum FailReason {
        case timeout
        case manual
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Circle()
                .fill(Color.red.opacity(0.1))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.red)
                )
            
            // Title
            Text("Quest failed")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
            
            // Body
            VStack(spacing: 8) {
                Text(reasonText)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.brandTextSecondary)
                
                Text("−\(penaltyXP) XP total")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("(-50 Resilience, -25 Stamina)") // Mock breakdown
                    .font(.caption)
                    .foregroundColor(.brandTextSecondary)
            }
            
            // Footer
            Text("It’s okay. Show up on the next one. Every attempt still builds your story.")
                .font(.caption)
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.brandNeutral)
                .padding(.top, 8)
            
            // Buttons
            VStack(spacing: 12) {
                Button(action: onDismiss) {
                    Text("Got it")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandBrownRich)
                        .cornerRadius(12)
                }
                
                Button(action: onDismiss) {
                    Text("See Stats")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandBrownRich)
                }
            }
            .padding(.top, 16)
        }
    }
    
    private var reasonText: String {
        switch reason {
        case .timeout:
            return "You didn’t complete this quest before the timer ran out."
        case .manual:
            return "You gave up on this quest before finishing."
        }
    }
}

