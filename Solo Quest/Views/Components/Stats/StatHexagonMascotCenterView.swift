//
//  StatHexagonMascotCenterView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatHexagonMascotCenterView: View {
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.5))
            .frame(width: 140, height: 140)
            .overlay(
                Image("SoloMascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .offset(y: 10)
            )
            .shadow(color: Color.brandBrownRich.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
