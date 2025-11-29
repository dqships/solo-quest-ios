//
//  ToastView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 11/30/2025.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 16) {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let actionTitle = actionTitle, let action = action {
                    Button(action: action) {
                        Text(actionTitle)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.brandAccentOrange)
                    }
                }
            }
            .padding()
            .background(Color.brandDarkText.opacity(0.95))
            .cornerRadius(12)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .shadow(radius: 10)
            .onAppear {
                // Auto dismiss after 4 seconds if no action is taken
                if action == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        onDismiss()
                    }
                }
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(200) // Ensure it's above tab bar if possible, or at least above content
        .onTapGesture {
            onDismiss()
        }
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        ToastView(
            message: "You're out of rerolls for today.",
            actionTitle: "Get More",
            action: {},
            onDismiss: {}
        )
    }
}

