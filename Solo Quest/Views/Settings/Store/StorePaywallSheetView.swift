//
//  StorePaywallSheetView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//  Modified by DaQuan Louden on 08-25-2026
//

import RevenueCat
import RevenueCatUI
import SwiftUI

struct StorePaywallSheetView: View {
    @ObservedObject var viewModel: StoreViewModel
    let paywallType: StorePaywallType
    @Environment(\.dismiss) private var dismiss
    @State private var offering: Offering?
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        ProgressView()
            .tint(.brandBrownRich)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.brandBackground)
            .task {
                await loadOffering()
            }
            .alert(paywallType.alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .presentPaywall(
                offering: $offering,
                presentationMode: .fullScreen,
                purchaseStarted: { package in
                    viewModel.handlePaywallPurchaseStarted(
                        package: package,
                        paywallType: paywallType
                    )
                },
                purchaseCompleted: { customerInfo in
                    viewModel.handlePaywallPurchaseCompleted(
                        transaction: nil,
                        customerInfo: customerInfo,
                        paywallType: paywallType
                    )
                },
                purchaseCancelled: {
                    viewModel.handlePaywallPurchaseCancelled(paywallType)
                },
                restoreCompleted: { customerInfo in
                    viewModel.handlePaywallRestoreCompleted(
                        customerInfo: customerInfo,
                        paywallType: paywallType
                    )
                },
                purchaseFailure: { error in
                    viewModel.handlePaywallPurchaseFailed(
                        error: error,
                        paywallType: paywallType
                    )
                    showFailure(error)
                },
                restoreFailure: { error in
                    viewModel.handlePaywallRestoreFailed(
                        error: error,
                        paywallType: paywallType
                    )
                    showFailure(error)
                },
                onDismiss: {
                    viewModel.handlePaywallDismissed()
                    dismiss()
                }
            )
    }

    @MainActor
    private func loadOffering() async {
        guard offering == nil else { return }

        do {
            let offerings = try await Purchases.shared.offerings()

            guard let offering = offerings.offering(identifier: paywallType.offeringIdentifier) else {
                alertMessage = String(localized: "Purchase options are unavailable right now. Please try again later.")
                showAlert = true
                return
            }

            self.offering = offering
            viewModel.handlePaywallViewed(paywallType)
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func showFailure(_ error: NSError) {
        alertMessage = error.localizedDescription
        showAlert = true
    }
}
