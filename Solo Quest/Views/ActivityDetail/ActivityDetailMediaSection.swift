//
//  ActivityDetailMediaSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import CoreData
import SwiftUI
import UIKit

struct ActivityDetailMediaSection: View {
    @Environment(\.managedObjectContext) private var context
    let quest: QuestInstance

    @State private var inputImage: UIImage?
    @State private var inputVideoURL: URL?
    @State private var imagePickerSource: ImagePickerSource?
    @State private var showingSourceSelection = false
    @State private var showingLimitAlert = false
    
    var body: some View {
        QuestAdventureLogSection(
            instance: quest,
            imagePickerSource: $imagePickerSource,
            showingSourceSelection: $showingSourceSelection,
            showingLimitAlert: $showingLimitAlert
        )
        .sheet(item: $imagePickerSource, onDismiss: {
            imagePickerSource = nil
        }) { source in
            ImagePicker(image: $inputImage, videoURL: $inputVideoURL, sourceType: source.sourceType)
                .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: inputImage) { _, newImage in
            guard let image = newImage else { return }
            AdventureAlbumManager.shared.saveImageToAdventureLog(image, quest: quest, context: context) { _ in }
        }
        .onChange(of: inputVideoURL) { _, newURL in
            guard let url = newURL else { return }
            AdventureAlbumManager.shared.saveVideoToAdventureLog(url, quest: quest, context: context) { _ in }
        }
    }
}
