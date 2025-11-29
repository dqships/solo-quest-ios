//
//  SettingsFooterView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct SettingsFooterView: View {
    let appVersion: String?
    let currentYear: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Solo Quest XP")
                .font(.headline)
                .foregroundColor(.brandDarkText)
            
            if let appVersion {
                Text("Version \(appVersion)")
                    .font(.subheadline)
                    .foregroundColor(.brandTextSecondary)
            }
            
            Text("© \(currentYear) Your Company. All rights reserved.")
                .font(.caption)
                .foregroundColor(.brandTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}
