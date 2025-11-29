//
//  RankDownModal.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct RankDownModal: View {
    let oldRank: String
    let newRank: String
    let currentLevel: Int
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Circle()
                .fill(Color.brandBrownDeep)
                .frame(width: 72, height: 72)
                .overlay(
                    Text(newRank)
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(.white)
                )
                .shadow(radius: 4)
            
            // Title
            Text("You dropped to Rank \(newRank)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
            
            // Body
            VStack(spacing: 8) {
                Text("Your XP fell below the threshold for Rank \(oldRank).")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.brandTextSecondary)
                
                HStack(spacing: 12) {
                    VStack {
                        Text("New Rank")
                            .font(.caption)
                            .foregroundColor(.brandTextSecondary)
                        Text(newRank)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.brandBrownRich)
                    }
                    
                    Divider()
                        .frame(height: 30)
                    
                    VStack {
                        Text("Current Level")
                            .font(.caption)
                            .foregroundColor(.brandTextSecondary)
                        Text("\(currentLevel)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.brandBrownRich)
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Motivation
            Text("This doesn’t erase your journey. It just means your next streak will matter even more.")
                .font(.caption)
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.brandNeutral)
                .padding(.top, 8)
            
            // Buttons
            VStack(spacing: 12) {
                Button(action: onDismiss) {
                    Text("Keep Going")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandBrownRich)
                        .cornerRadius(12)
                }
                
                Button(action: onDismiss) {
                    Text("View Stats")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandBrownRich)
                }
            }
            .padding(.top, 16)
        }
    }
}

