//
//  AccountDataPreparationView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import SwiftUI

struct AccountDataPreparationView: View {
    let message: String
    let canRetry: Bool
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            if !canRetry {
                ProgressView()
                    .accessibilityLabel(AccountDataBootstrapCopy.preparing)
            }
            Text(message)
                .multilineTextAlignment(.center)
            if canRetry {
                Button(AccountDataBootstrapCopy.retry, action: retryAction)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .frame(maxWidth: 420)
    }
}
