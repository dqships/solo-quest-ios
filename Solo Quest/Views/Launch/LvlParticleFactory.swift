//
//  LvlParticleFactory.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

enum LvlParticleFactory {
    static func makeParticles(count: Int) -> [LvlParticle] {
        let laneWidth = 1.0 / CGFloat(count)
        var delays = (0..<count).map { Double($0) * 0.5 }
        delays.shuffle()
        
        return (0..<count).map { index in
            let laneStart = CGFloat(index) * laneWidth
            let x = laneStart + (laneWidth * 0.5) + CGFloat.random(in: -0.05...0.05)
            
            return LvlParticle(
                x: x,
                scale: CGFloat.random(in: 1.5...2.5),
                rotation: Double.random(in: -15...15),
                speed: Double.random(in: 3.5...5.5),
                delay: delays[index]
            )
        }
    }
}
