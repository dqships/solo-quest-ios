//
//  StoreProductCard.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct StoreProductCard: View {
    let product: StoreProduct
    let action: () -> Void
    
    private var isRerollPack: Bool {
        product.type == .reroll
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: isRerollPack ? 0 : 12) {
                HStack(alignment: .top) {
                    Image(product.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isRerollPack ? 75 : 50, height: isRerollPack ? 75 : 50)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        if product.type == .subscription {
                            Image(product.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                        }
                        
                        Text(product.price)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.brandBrownRich)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.brandDarkText)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(product.description)
                        .font(.caption)
                        .foregroundColor(.brandTextSecondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(isRerollPack ? 12 : 16)
            .frame(width: 160, height: 150)
            .background(Color.brandCardSurface)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
