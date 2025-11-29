//
//  StoreProductSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct StoreProductSectionView<Accessory: View>: View {
    let title: LocalizedStringKey
    let products: [StoreProduct]
    let purchase: (StoreProduct) -> Void
    @ViewBuilder let accessory: () -> Accessory
    
    init(
        title: LocalizedStringKey,
        products: [StoreProduct],
        purchase: @escaping (StoreProduct) -> Void,
        @ViewBuilder accessory: @escaping () -> Accessory
    ) {
        self.title = title
        self.products = products
        self.purchase = purchase
        self.accessory = accessory
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.brandDarkText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                accessory()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        StoreProductCard(product: product) {
                            purchase(product)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

extension StoreProductSectionView where Accessory == EmptyView {
    init(
        title: LocalizedStringKey,
        products: [StoreProduct],
        purchase: @escaping (StoreProduct) -> Void
    ) {
        self.init(title: title, products: products, purchase: purchase) {
            EmptyView()
        }
    }
}
