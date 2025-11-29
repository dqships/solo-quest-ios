//
//  RestrictedAccessView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct RestrictedAccessView: View {
    let message: String
    let iconName: String
    
    var body: some View {
        ZStack {
            Color.brandBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: iconName)
                    .font(.system(size: 64))
                    .foregroundColor(.brandNeutral.opacity(0.5))
                
                Text(message)
                    .font(.headline)
                    .foregroundColor(.brandDarkText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    RestrictedAccessView(
        message: "You cannot level up without being signed in. Without an account.",
        iconName: "lock.fill"
    )
}

