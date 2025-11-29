//
//  MoodPoseModifier.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct MoodPoseModifier: ViewModifier {
    let mood: MascotView.Mood
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch mood {
        case .hero:
            content
                .shadow(radius: 12)
        case .explain:
            content
                .scaleEffect(0.9)
                .offset(x: -20)
        case .auth:
            content
                .scaleEffect(0.9)
        case .think:
            content
                .scaleEffect(0.9)
        case .time:
            content
                .rotationEffect(.degrees(-4))
        case .warn:
            content
                .scaleEffect(0.95)
        }
    }
}
