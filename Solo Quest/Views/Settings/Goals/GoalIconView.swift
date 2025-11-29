//
//  GoalIconView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct GoalIconView: View {
    let goal: String
    
    var body: some View {
        switch goal {
        case "Build Confidence":
            Image(systemName: "person.fill.checkmark")
        case "Meet New People":
            Image(systemName: "person.2.fill")
        case "Get Fit & Healthy":
            Image(systemName: "figure.run")
        case "Stop Procrastinating":
            Image(systemName: "clock.arrow.circlepath")
        case "Try New Things":
            Image(systemName: "dice.fill")
        case "Learn & Grow":
            Image(systemName: "brain.head.profile")
        default:
            Image(systemName: "star.fill")
        }
    }
}
