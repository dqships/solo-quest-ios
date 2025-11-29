//
//  FantasyQuestActionButton.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct FantasyQuestActionButton: View {
    let instance: QuestInstance
    let onAccept: ((QuestInstance) -> Void)?
    let onComplete: ((QuestInstance) -> Void)?
    
    var body: some View {
        switch instance.state {
        case "available":
            Button(action: { onAccept?(instance) }) {
                Text("ACCEPT")
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.brandBrownRich)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
        case "active":
            Button(action: { onComplete?(instance) }) {
                Text("COMPLETE")
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.brandAccentOrange)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
        case "locked":
            Button(action: {}) {
                Text("LOCKED")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.brandTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.brandNeutral.opacity(0.3))
                    .cornerRadius(12)
            }
            .disabled(true)
            
        case "completed":
            Button(action: {}) {
                Text("DONE")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.brandBrownRich.opacity(0.2))
                    .cornerRadius(12)
            }
            .disabled(true)
            
        case "failed":
            Button(action: {}) {
                Text("FAILED")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(12)
            }
            .disabled(true)
            
        default:
            EmptyView()
        }
    }
}
