//
//  QuestCardAnimationView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct QuestCardAnimationView: View {
    enum AnimationType {
        case accepted
        case completed
        case failed
        
        var title: LocalizedStringKey {
            switch self {
            case .accepted: return "Accepted!"
            case .completed: return "Completed!"
            case .failed: return "Failed!"
            }
        }
        
        var color: Color {
            switch self {
            case .accepted: return Color.brandBrownRich
            case .completed: return Color.brandBrownRich
            case .failed: return .red
            }
        }
    }
    
    let type: AnimationType
    let onFinished: () -> Void
    
    @State private var scale: CGFloat = 0.01
    @State private var rotation: Double = 0
    @State private var showText: Bool = false
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack {
                Image("QuestCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
                
                if showText {
                    Text(type.title)
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(type.color)
                        .shadow(color: .white, radius: 0, x: 2, y: 2) // Outline effect
                        .shadow(color: .white, radius: 0, x: -2, y: -2)
                        .shadow(color: .white, radius: 0, x: 2, y: -2)
                        .shadow(color: .white, radius: 0, x: -2, y: 2)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 4)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .opacity(opacity)
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        if AppStoreScreenshotMode.isEnabled {
            scale = 1.0
            rotation = 0
            showText = true
            opacity = 1.0
            return
        }

        // Spin and grow
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            scale = 1.0
            rotation = 720 // 2 full spins
        }
        
        // Show text after spin
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring()) {
                showText = true
            }
        }
        
        // Dismiss after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onFinished()
            }
        }
    }
}
