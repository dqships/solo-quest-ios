//
//  StoreViewModel+Products.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation

extension StoreViewModel {
    func loadProducts() {
        subscriptions = StoreProductCatalog.subscriptions
        rerollPacks = StoreProductCatalog.rerollPacks
    }
}
