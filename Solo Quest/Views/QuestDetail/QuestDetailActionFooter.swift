//
//  QuestDetailActionFooter.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct QuestDetailActionFooter: View {
    let instance: QuestInstance
    let acceptQuest: () -> Void
    let completeQuest: () -> Void
    let failQuest: () -> Void
    
    var body: some View {
        switch instance.state {
        case "available":
            Button(action: acceptQuest) {
                Text("Accept Quest")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandBrownRich)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            
        case "locked":
            VStack(spacing: 8) {
                if let activation = instance.activationTime {
                    HStack(spacing: 4) {
                        Text("Unlocks in")
                        Text(activation, style: .timer)
                            .monospacedDigit()
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.brandBrownDeep)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(Color.brandBrownHighlight.opacity(0.2))
                    .cornerRadius(16)
                }
                
                Button(action: {}) {
                    Text("Complete Quest")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.brandTextSecondary.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandNeutral.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(true)
            }
            
        case "active":
            VStack(spacing: 8) {
                Button(action: completeQuest) {
                    Text("Mark Complete")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandAccentOrange)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                
                Button(action: failQuest) {
                    Text("Give Up")
                        .font(.subheadline)
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.top, 8)
                }
            }
            
        default:
            EmptyView()
        }
    }
}
