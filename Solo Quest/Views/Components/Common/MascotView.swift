//
//  MascotView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct MascotView: View {
    enum Mood {
        case hero    // big, welcoming
        case explain // off to the side, pointing
        case auth    // security/login
        case think   // next to text field
        case time    // reminder screen
        case warn    // safety disclaimer
    }

    let mood: Mood

    @State private var bob = false

    var body: some View {
        Image("SoloMascot") // Using the single asset for now
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 220)
            .offset(y: bob ? -6 : 0)
            .animation(
                .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                value: bob
            )
            .onAppear { bob = true }
            .modifier(MoodPoseModifier(mood: mood))
    }
}
