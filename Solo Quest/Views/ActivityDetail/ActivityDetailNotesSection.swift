//
//  ActivityDetailNotesSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct ActivityDetailNotesSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.brandDarkText)
            
            Text(content)
                .font(.body)
                .foregroundColor(.brandTextSecondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.brandCardSurface)
                .cornerRadius(12)
        }
    }
}
