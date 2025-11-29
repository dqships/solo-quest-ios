//
//  LaunchScreenView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var mascotScale: CGFloat = 0.5
    @State private var mascotOpacity: Double = 0.0
    @State private var mascotRotation: Double = 0.0
    
    private let lvlParticles = LvlParticleFactory.makeParticles(count: 6)

    var body: some View {
        ZStack {
            // Brand Background
            Color.brandBackground
                .ignoresSafeArea()
            
            // Rain Effect (Falling Lvl+ Images)
            GeometryReader { geometry in
                ForEach(lvlParticles) { particle in
                    LvlRainDrop(config: particle, screenSize: geometry.size)
                }
            }
            
            // Title Text
            VStack {
                Text("Solo Quest XP")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.brandDarkText)
                    .padding(.top, 80)
                    .shadow(color: .white, radius: 0, x: 2, y: 0)
                    .shadow(color: .white, radius: 0, x: -2, y: 0)
                    .shadow(color: .white, radius: 0, x: 0, y: 2)
                    .shadow(color: .white, radius: 0, x: 0, y: -2)
                
                Spacer()
            }
            
            // Mascot Animation (Foreground)
            Image("SoloMascot") // Ensure asset name matches SoloMascot.imageset
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .shadow(color: .white, radius: 0, x: 2, y: 0)
                .shadow(color: .white, radius: 0, x: -2, y: 0)
                .shadow(color: .white, radius: 0, x: 0, y: 2)
                .shadow(color: .white, radius: 0, x: 0, y: -2)
                .scaleEffect(mascotScale)
                .opacity(mascotOpacity)
                .rotationEffect(.degrees(mascotRotation), anchor: .bottom)
                .onAppear {
                    // 1. Spring Appearance
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0)) {
                        mascotScale = 1.0
                        mascotOpacity = 1.0
                    }
                    
                    // 2. Tipping Animation (Sequence)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        // First tip to the right
                        withAnimation(.easeInOut(duration: 1.0)) {
                            mascotRotation = 5.0
                        }
                        
                        // Then continuous swaying left and right
                        withAnimation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                            .delay(1.0)
                        ) {
                            mascotRotation = -5.0
                        }
                    }
                }
        }
    }
}

#Preview {
    LaunchScreenView()
}
