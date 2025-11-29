//
//  AppStoreScreenshotLoreImageView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-29-2026
//

import SwiftUI
import UIKit

struct AppStoreScreenshotLoreImageView: View {
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
            }
        }
        .statusBarHidden(true)
        .onAppear {
            image = UIImage(contentsOfFile: loreImageURL.path)
        }
    }

    private var loreImageURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("AppStoreScreenshots")
            .appendingPathComponent(AppStoreScreenshotFixtureValues.loreImageFilename)
    }
}
