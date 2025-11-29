//
//  EmptyAdventureLogView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//  Updated by DaQuan Louden on 05-29-2026
//

import SwiftUI

struct EmptyAdventureLogView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: verticalSpacing) {
            VStack(spacing: 8) {
                Text("Your Adventure Awaits")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.brandDarkText)
                
                Text("Complete quests and capture memories to fill your log with epic moments like these!")
                    .font(.subheadline)
                    .foregroundColor(.brandTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: textWidth)
            }
            .padding(.top, 8)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(SampleAdventureImageProvider.displayImages, id: \.self) { imageName in
                    SampleAdventureThumbnail(imageName: imageName)
                }
            }
            .frame(maxWidth: gridWidth)
            .padding(.horizontal, horizontalPadding)
            .opacity(0.85)
        }
        .frame(maxWidth: .infinity)
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)
    }

    private var columnCount: Int {
        isRegularWidth ? 4 : 3
    }

    private var gridWidth: CGFloat {
        isRegularWidth ? 720 : 360
    }

    private var horizontalPadding: CGFloat {
        isRegularWidth ? 32 : 16
    }

    private var isRegularWidth: Bool {
        horizontalSizeClass == .regular
    }

    private var spacing: CGFloat {
        isRegularWidth ? 14 : 8
    }

    private var textWidth: CGFloat {
        isRegularWidth ? 460 : 330
    }

    private var verticalSpacing: CGFloat {
        isRegularWidth ? 24 : 20
    }
}
