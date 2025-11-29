//
//  PersonalityAssessmentContinueButton.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct PersonalityAssessmentContinueButton: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Button(action: action) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandBrownRich)
                    .foregroundColor(Color.brandBackground)
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
        .padding(.top, 12)
        .background(
            LinearGradient(
                colors: [Color.brandCardSurface.opacity(0), Color.brandCardSurface],
                startPoint: .top,
                endPoint: .center
            )
        )
    }
}
