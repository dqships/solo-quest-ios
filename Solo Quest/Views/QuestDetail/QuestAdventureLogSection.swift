//
//  QuestAdventureLogSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Factory
import CoreData
import UIKit

struct QuestAdventureLogSection: View {
    @Injected(\.storeKitService) private var storeKitService
    @Environment(\.managedObjectContext) private var context
    let instance: QuestInstance
    @Binding var imagePickerSource: ImagePickerSource?
    @Binding var showingSourceSelection: Bool
    @Binding var showingLimitAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Adventure Log")
                    .font(.headline)
                    .foregroundColor(.brandDarkText)
                
                Spacer()
                
                if canAddMedia {
                    Button(action: addPhoto) {
                        Label("Add Photo", systemImage: "camera.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.brandAccentOrange)
                            .cornerRadius(16)
                    }
                    .alert("Media Limit Reached", isPresented: $showingLimitAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(
                            storeKitService.isPro
                                ? String(localized: "You have reached the maximum of 10 items per quest.")
                                : String(localized: "Free users can add up to 3 items per quest. Get a Guild Pass to add up to 10!")
                        )
                    }
                    .confirmationDialog("Add Media", isPresented: $showingSourceSelection) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            Button("Camera") {
                                imagePickerSource = .camera
                            }
                        }
                        Button("Photo Library") {
                            imagePickerSource = .photoLibrary
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
            }
            .padding(.horizontal)
            
            QuestMediaSectionView(quest: instance)
        }
    }

    private var canAddMedia: Bool {
        instance.state == "active" || instance.state == "locked" || instance.state == "completed"
    }
    
    private func addPhoto() {
        let limit = storeKitService.isPro ? 10 : 3
        let currentCount = AdventureAlbumManager.shared.fetchMediaItems(for: instance, context: context).count
        
        if currentCount >= limit {
            showingLimitAlert = true
        } else {
            showingSourceSelection = true
        }
    }
}
