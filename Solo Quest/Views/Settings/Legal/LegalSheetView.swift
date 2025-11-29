//
//  LegalSheetView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct LegalSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brandBackground.ignoresSafeArea()
                
                TabView {
                    LegalContentView(text: LegalData.termsOfService)
                        .tabItem {
                            Label("Terms", systemImage: "doc.text")
                        }
                    
                    LegalContentView(text: LegalData.privacyPolicy)
                        .tabItem {
                            Label("Privacy", systemImage: "hand.raised")
                        }
                }
                .accentColor(.brandBrownRich)
            }
            .navigationTitle("Legal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.brandBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.brandBrownRich)
                }
            }
        }
    }
}
