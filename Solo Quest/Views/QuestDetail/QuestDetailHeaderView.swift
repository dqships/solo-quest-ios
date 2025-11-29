//
//  QuestDetailHeaderView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestDetailHeaderView: View {
    let questRank: String
    let title: String
    let state: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Image("RankBadge\(questRank)")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            QuestStatusBadge(state: state)
        }
        .padding(.top, 32)
    }
}
