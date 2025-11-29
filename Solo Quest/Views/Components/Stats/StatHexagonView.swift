//
//  StatHexagonView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatHexagonView: View {
    let userStats: UserStatBlock
    let statTaglines: [String: String]
    let onSelectStat: (String) -> Void
    let getRank: (Int) -> String
    
    var body: some View {
        ZStack {
            StatHexagonMascotCenterView()
            
            GeometryReader { geometry in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius: CGFloat = 130
                
                ForEach(0..<StatHexagonLayout.statsOrder.count, id: \.self) { index in
                    let statName = StatHexagonLayout.statsOrder[index]
                    let angle = Angle(degrees: Double(index) * 60 - 90)
                    let x = center.x + radius * cos(CGFloat(angle.radians))
                    let y = center.y + radius * sin(CGFloat(angle.radians))
                    let xp = getStatValue(statName)
                    let rank = getRank(xp)
                    
                    NavigationLink(value: AppRoute.statDetail(
                        statName: statName,
                        currentXP: xp,
                        tagline: statTaglines[statName] ?? ""
                    )) {
                        StatBubble(
                            statName: statName,
                            xp: xp,
                            rank: rank
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .position(x: x, y: y)
                }
            }
        }
        .frame(height: 360)
    }
    
    private func getStatValue(_ name: String) -> Int {
        switch name {
        case "luck": return userStats.luck
        case "charisma": return userStats.charisma
        case "strength": return userStats.strength
        case "stamina": return userStats.stamina
        case "resilience": return userStats.resilience
        case "intelligence": return userStats.intelligence
        default: return 0
        }
    }
}
