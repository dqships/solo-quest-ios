//
//  SampleAdventureThumbnail.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Updated by DaQuan Louden on 05-29-2026
//

import SwiftUI

struct SampleAdventureThumbnail: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size.width

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.brandNeutral.opacity(0.2), lineWidth: 1)
                )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
