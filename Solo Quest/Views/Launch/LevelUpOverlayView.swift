//
//  LevelUpOverlayView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct LevelUpOverlayView: View {
    let previousLevel: Int
    let newLevel: Int
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = -10
    @State private var levelTextOpacity: Double = 0.0

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Image("LvlPlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(rotation))
                    .shadow(color: Color.brandAccentOrange.opacity(0.6), radius: 20, x: 0, y: 0)

                Text("Level Up!")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.brandBrownRich)

                Text("Level \(previousLevel) → Level \(newLevel)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.brandDarkText)
                    .opacity(levelTextOpacity)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
            .background(Color.brandBackground.opacity(0.9))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.brandBrownRich, lineWidth: 3)
            )
            .opacity(opacity)
            .scaleEffect(scale)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .onTapGesture {
                onDismiss()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
                rotation = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeIn(duration: 0.3)) {
                    levelTextOpacity = 1.0
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onDismiss()
            }
        }
    }
}
