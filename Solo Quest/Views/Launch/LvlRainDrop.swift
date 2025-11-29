//
//  LvlRainDrop.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct LvlRainDrop: View {
    let config: LvlParticle
    let screenSize: CGSize
    
    @State private var isAnimating = false
    
    var body: some View {
        Image("LvlPlus")
            .resizable()
            .scaledToFit()
            .frame(width: 60 * config.scale)
            .rotationEffect(.degrees(config.rotation))
            .position(
                x: screenSize.width * config.x,
                y: isAnimating ? screenSize.height + 200 : -200
            )
            .opacity(0.7)
            .onAppear {
                withAnimation(
                    .linear(duration: config.speed)
                    .repeatForever(autoreverses: false)
                    .delay(config.delay)
                ) {
                    isAnimating = true
                }
            }
    }
}
