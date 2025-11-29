//
//  SettingsPreferencesSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct SettingsPreferencesSectionView: View {
    @Binding var isNotificationsEnabled: Bool
    @Binding var isDarkModeEnabled: Bool
    let locationStatusTitle: String
    let locationActionTitle: String
    let isRequestingLocation: Bool
    let handleLocationPersonalizationTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferences")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "bell.fill",
                    title: "Daily Reminders",
                    isOn: $isNotificationsEnabled
                )
                
                Divider()
                    .background(Color.brandNeutral.opacity(0.3))
                    .padding(.vertical, 8)
                
                ToggleRow(
                    icon: "moon.fill",
                    title: "Dark Mode",
                    isOn: $isDarkModeEnabled
                )

                Divider()
                    .background(Color.brandNeutral.opacity(0.3))
                    .padding(.vertical, 8)

                SettingsLocationPersonalizationRow(
                    statusTitle: locationStatusTitle,
                    actionTitle: locationActionTitle,
                    isRequesting: isRequestingLocation,
                    action: handleLocationPersonalizationTap
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
