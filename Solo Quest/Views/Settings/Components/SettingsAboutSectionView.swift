//
//  SettingsAboutSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct SettingsAboutSectionView: View {
    let isRestoringPurchases: Bool
    let requestReview: () -> Void
    let showHelp: () -> Void
    let showTerms: () -> Void
    let restorePurchases: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .padding(.horizontal)
            
            VStack(spacing: 1) {
                SettingsButtonRow(
                    icon: "star.bubble.fill",
                    title: "Leave a Review",
                    action: requestReview
                )
                
                Divider().background(Color.brandNeutral.opacity(0.3))

                SettingsButtonRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    action: showHelp
                )
                
                Divider().background(Color.brandNeutral.opacity(0.3))
                
                SettingsButtonRow(
                    icon: "doc.text.fill",
                    title: "Terms & Privacy",
                    action: showTerms
                )
                
                Divider().background(Color.brandNeutral.opacity(0.3))
                
                RestorePurchasesRow(
                    isLoading: isRestoringPurchases,
                    action: restorePurchases
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
