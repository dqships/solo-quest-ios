//
//  SettingsDataSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import SwiftUI

struct SettingsDataSectionView: View {
    let isClearingData: Bool
    let requestClearData: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .padding(.horizontal)

            VStack(spacing: 1) {
                SettingsClearDataRow(
                    isClearingData: isClearingData,
                    requestClearData: requestClearData
                )
            }
            .padding()
            .background(Color.brandCardSurface)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
            .padding(.horizontal)
        }
    }
}
