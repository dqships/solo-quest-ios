//
//  QuestCardActionButton.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct QuestCardActionButton: View {
    let instance: QuestInstance
    let onAccept: ((QuestInstance) -> Void)?
    let onComplete: ((QuestInstance) -> Void)?
    
    var body: some View {
        switch instance.state {
        case "available":
            Button(action: { onAccept?(instance) }) {
                Text("Accept")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.brandBrownRich)
                    .cornerRadius(8)
            }
            
        case "locked":
            Button(action: { onComplete?(instance) }) {
                Text("Complete")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.brandTextSecondary.opacity(0.5))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.brandNeutral.opacity(0.3))
                    .cornerRadius(8)
            }
            .disabled(true)
            
        case "active":
            Button(action: { onComplete?(instance) }) {
                Text("Mark Complete")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.brandAccentOrange)
                    .cornerRadius(8)
            }
            
        default:
            EmptyView()
        }
    }
}
