//
//  ActivityDetailQuestInfoSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct ActivityDetailQuestInfoSection: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quest Details")
                .font(.headline)
                .foregroundColor(.brandDarkText)
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.brandCardSurface)
                .cornerRadius(12)
        }
    }
}
