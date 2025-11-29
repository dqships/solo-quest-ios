//
//  QuestListHeaderActionRow.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-24-2026
//

import SwiftUI

struct QuestListHeaderActionRow: View {
    let showSettings: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            QuestListProfileButton(showSettings: showSettings)
            
            Spacer()
        }
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
