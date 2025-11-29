//
//  SettingsHelpModalView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct SettingsHelpModalView: View {
    let supportCode: String
    let close: () -> Void
    
    var body: some View {
        GenericModalView {
            VStack(spacing: 20) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.brandAccentOrange)
                
                VStack(spacing: 8) {
                    Text("Help & Support")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.brandDarkText)
                    
                    Text("Need help? Contact us at:")
                        .font(.body)
                        .foregroundColor(.brandTextSecondary)
                    
                    Text("support@example.com")
                        .font(.headline)
                        .foregroundColor(.brandBrownRich)
                        .padding(8)
                        .background(Color.brandCardSurface)
                        .cornerRadius(8)
                }

                SettingsSupportCodeView(supportCode: supportCode)
                
                Button(action: close) {
                    Text("Close")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandBrownRich)
                        .cornerRadius(12)
                }
            }
        }
    }
}
