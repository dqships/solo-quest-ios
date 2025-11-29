//
//  GenericModalView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/29/2025.
//

import SwiftUI

struct GenericModalView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .transition(.opacity)
            
            // Modal Card
            VStack(spacing: 20) {
                content
            }
            .padding(24)
            .background(Color.brandBackground)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 24)
            .transition(.scale.combined(with: .opacity))
        }
        .zIndex(100)
    }
}

