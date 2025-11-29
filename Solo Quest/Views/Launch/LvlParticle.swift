//
//  LvlParticle.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct LvlParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let scale: CGFloat
    let rotation: Double
    let speed: Double
    let delay: Double
}
