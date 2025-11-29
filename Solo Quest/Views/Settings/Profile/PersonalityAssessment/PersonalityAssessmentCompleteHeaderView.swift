//
//  PersonalityAssessmentCompleteHeaderView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct PersonalityAssessmentCompleteHeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Assessment Complete!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.brandDarkText)

            Text("You have incredible potential.")
                .font(.headline)
                .foregroundColor(.brandDarkText)
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)

            Text("Based on your answers, you're starting at:")
                .font(.body)
                .foregroundStyle(Color.brandDarkText)
        }
        .padding(.horizontal)
    }
}
