//
//  RankUpOverlayView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct RankUpOverlayView: View {
    let previousRank: String
    let newRank: String
    let onDismiss: () -> Void

    @State private var textOpacity: Double = 0.0
    @State private var textScale: CGFloat = 0.5
    @State private var oldBadgeOpacity: Double = 1.0
    @State private var oldBadgeScale: CGFloat = 1.0
    @State private var oldBadgeShakeOffset: CGFloat = 0
    @State private var newBadgeOpacity: Double = 0.0
    @State private var newBadgeScale: CGFloat = 0.3
    @State private var newBadgeRotation: Double = -180
    @State private var showNewBadge: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Text("You've Been Promoted!")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.brandBrownRich)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.brandBackground.opacity(0.95))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.brandAccentOrange, lineWidth: 3)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .opacity(textOpacity)
                    .scaleEffect(textScale)

                ZStack {
                    Image("RankBadge\(previousRank)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .opacity(oldBadgeOpacity)
                        .scaleEffect(oldBadgeScale)
                        .offset(x: oldBadgeShakeOffset)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)

                    if showNewBadge {
                        Image("RankBadge\(newRank)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)
                            .opacity(newBadgeOpacity)
                            .scaleEffect(newBadgeScale)
                            .rotationEffect(.degrees(newBadgeRotation))
                            .shadow(color: Color.brandAccentOrange.opacity(0.6), radius: 20, x: 0, y: 0)
                    }
                }

                Text("Rank \(previousRank) → Rank \(newRank)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.brandDarkText)
                    .opacity(newBadgeOpacity)
            }
            .onTapGesture {
                onDismiss()
            }
        }
        .onAppear {
            runAnimation()
        }
    }

    private func runAnimation() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            textOpacity = 1.0
            textScale = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            shakeOldBadge()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            transformToNewBadge()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            onDismiss()
        }
    }

    private func shakeOldBadge() {
        let shakeDuration = 0.08
        let shakeCount = 8

        for i in 0..<shakeCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * shakeDuration) {
                withAnimation(.linear(duration: shakeDuration)) {
                    oldBadgeShakeOffset = i % 2 == 0 ? 12 : -12
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(shakeCount) * shakeDuration) {
            withAnimation(.linear(duration: shakeDuration)) {
                oldBadgeShakeOffset = 0
            }
        }
    }

    private func transformToNewBadge() {
        withAnimation(.easeIn(duration: 0.3)) {
            oldBadgeScale = 0.5
            oldBadgeOpacity = 0.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showNewBadge = true
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                newBadgeOpacity = 1.0
                newBadgeScale = 1.0
                newBadgeRotation = 0
            }
        }
    }
}
