//
//  StoreView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Factory
import SwiftUI

struct StoreView: View {
    @StateObject private var viewModel = StoreViewModel()
    @Environment(\.dismiss) var dismiss
    @Injected(\.analyticsManager) private var analytics
    @State private var selectedPaywall: StorePaywallType?
    let source: PaywallSource

    init(source: PaywallSource = .store) {
        self.source = source
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brandBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        StorePaywallEntryCard(
                            title: "Unlock Guild Pass",
                            subtitle: "Daily protection + unlimited rerolls",
                            icon: "ProMembership"
                        ) {
                            openPaywall(.guildPass)
                        }
                        
                        StorePaywallEntryCard(
                            title: "Buy Rerolls",
                            subtitle: "Add rerolls to your balance",
                            icon: "QuestPack50"
                        ) {
                            openPaywall(.rerolls)
                        } accessory: {
                            StoreCounterBadge(
                                icon: "arrow.triangle.2.circlepath",
                                text: "\(viewModel.rerollBalance)",
                                background: Color.brandAccentOrange.opacity(0.15)
                            )
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: 800)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Store")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.brandBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.brandBrownRich)
                }
            }
        }
        .onAppear {
            analytics.trackStoreViewed()
        }
        .sheet(item: $selectedPaywall) { paywallType in
            StorePaywallSheetView(
                viewModel: viewModel,
                paywallType: paywallType
            )
        }
    }

    private func openPaywall(_ paywallType: StorePaywallType) {
        viewModel.handlePaywallSelected(paywallType, source: source.rawValue)
        selectedPaywall = paywallType
    }
}
