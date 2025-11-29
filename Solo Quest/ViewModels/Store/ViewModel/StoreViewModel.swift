//
//  StoreViewModel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//  Modified by DaQuan Louden on 08-25-2026
//

import Combine
import Factory
import Foundation

@MainActor
class StoreViewModel: ObservableObject {
    @Injected(\.storeKitService) var storeKit
    @Injected(\.persistenceController) var persistence
    @Injected(\.analyticsManager) var analytics
    @Injected(\.accountScopeProvider) var accountScopeProvider

    @Published var subscriptions: [StoreProduct] = []
    @Published var rerollPacks: [StoreProduct] = []
    @Published var rerollBalance: Int = 0
    @Published var isPro: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var cancellables = Set<AnyCancellable>()
    var activePaywallProductId: String?
    var processedPaywallTransactionIds = Set<String>()
    var activePaywallSource = PaywallSource.store.rawValue
    var activePaywallCustomerInfoToken: ExternalCustomerInfoToken?

    init() {
        loadProducts()
        loadUserData()
        setupObservers()
    }
}
