//
//  AdventurerProfileAssessmentView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import SwiftUI

struct AdventurerProfileAssessmentView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        PersonalityAssessmentView(onFinished: { dismiss() })
            .background(Color.brandBackground)
    }
}
