//
//  SettingsHeaderView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct SettingsHeaderView: View {
    let rank: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image("RankBadge\(rank)")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.brandDarkText)

                Text("Rank \(rank)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.brandTextSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
