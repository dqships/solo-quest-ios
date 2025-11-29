//
//  SettingsSignOutButton.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Clerk

struct SettingsSignOutButton: View {
    @Environment(\.clerk) private var clerk
    let signOut: () -> Void
    
    var body: some View {
        if clerk.user != nil {
            Button(action: signOut) {
                Text("Sign Out")
                    .fontWeight(.bold)
                    .foregroundColor(.red.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandCardSurface)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }
}
