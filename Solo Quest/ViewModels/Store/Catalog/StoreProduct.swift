//
//  StoreProduct.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import Foundation
import SwiftUI

struct StoreProduct: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let price: String
    let type: ProductType
    let icon: String
    let color: Color
    let productId: String

    enum ProductType {
        case subscription
        case reroll
    }
}
