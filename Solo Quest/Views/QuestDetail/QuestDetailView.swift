//
//  QuestDetailView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI
import Factory
import CoreData
import PhotosUI

struct QuestDetailView: View {
    @Injected(\.questEngine) private var questEngine
    @Injected(\.analyticsManager) private var analytics
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentationMode

    let instance: QuestInstance
    let template: QuestTemplate?
    var onAccept: ((QuestInstance) -> Void)?
    var onComplete: ((QuestInstance) -> Void)?
    var onFail: ((QuestInstance) -> Void)?
    
    @State private var inputImage: UIImage?
    @State private var inputVideoURL: URL?
    @State private var imagePickerSource: ImagePickerSource?
    @State private var showingSourceSelection = false
    @State private var showingLimitAlert = false
    @State private var showingNotesEditor = false
    @State private var notesText: String = ""
    
    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    QuestDetailHeaderView(
                        questRank: questRank,
                        title: displayTitle,
                        state: instance.state
                    )
                    
                    QuestDetailRewardsView(
                        xpReward: xpReward,
                        durationString: durationString,
                        xpLoss: xpLoss,
                        affectedStats: affectedStats,
                        noviceProtectionActive: questEngine.newPlayerProtection.isActive()
                    )
                    
                    if let template = template {
                        QuestFilterTagsView(template: template)
                    }
                    
                    QuestInstructionsCard(
                        instructions: displayTitle,
                        isAvailable: instance.state == "available"
                    )

                    QuestNotesCard(
                        notes: instance.notes,
                        editNotes: editNotes
                    )
                    
                    QuestAdventureLogSection(
                        instance: instance,
                        imagePickerSource: $imagePickerSource,
                        showingSourceSelection: $showingSourceSelection,
                        showingLimitAlert: $showingLimitAlert
                    )
                    
                    Spacer(minLength: 40)
                }
                .padding(.bottom, 100)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .keyboardDismissalEnabled()
        }
        .overlay(
            VStack {
                Spacer()
                QuestDetailActionFooter(
                    instance: instance,
                    acceptQuest: acceptQuest,
                    completeQuest: completeQuest,
                    failQuest: failQuest
                )
                .padding()
                .padding(.bottom, 16)
                .frame(maxWidth: 640)
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingNotesEditor) {
            NavigationView {
                TextEditor(text: $notesText)
                    .padding()
                    .navigationTitle("Quest Notes")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingNotesEditor = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let trimmed = notesText.trimmingCharacters(in: .whitespacesAndNewlines)
                                instance.notes = trimmed.isEmpty ? nil : trimmed
                                try? context.save()
                                showingNotesEditor = false
                            }
                        }
                    }
            }
            .keyboardDismissalEnabled()
            .presentationDetents([.medium, .large])
        }
        .sheet(item: $imagePickerSource, onDismiss: {
            imagePickerSource = nil
        }) { source in
            ImagePicker(image: $inputImage, videoURL: $inputVideoURL, sourceType: source.sourceType)
                .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: inputImage) { _, newImage in
            if let image = newImage {
                AdventureAlbumManager.shared.saveImageToAdventureLog(image, quest: instance, context: context) { success in
                    if !success {
                        // In case the manager rejects it (race condition or other error)
                        // Could add a toast here if needed
                    }
                }
            }
        }
        .onChange(of: inputVideoURL) { _, newURL in
            if let url = newURL {
                AdventureAlbumManager.shared.saveVideoToAdventureLog(url, quest: instance, context: context) { success in
                    if !success {
                         // Handle error
                    }
                }
            }
        }
        .onAppear {
            let stats = questEngine.fetchOrCreateUserStats(context: context)
            analytics.track(event: "quest_detail_opened", properties: QuestAnalyticsProperties.make(
                quest: instance,
                userStats: stats,
                isPro: questEngine.storeKit.isPro,
                isFirstQuest: stats.totalXP == 0,
                source: "quest_detail",
                template: template,
                extra: questEngine.retentionAnalyticsProperties(context: context).merging([
                    "matches_all_preferences": template.map {
                        questEngine.matchesAllPreferences(
                            quest: $0,
                            filterPrefs: questEngine.getFilterPreferences()
                        )
                    } ?? false
                ], uniquingKeysWith: { _, new in new })
            ))
        }
    }

    private var displayTitle: String {
        questEngine.getLocalizedDisplayTitle(for: instance, template: template)
    }

    private var durationString: String {
        guard let template = template else { return "15 min" }
        let config = questEngine.getDuration(size: template.size)
        if config.minMinutes == config.maxMinutes {
            return "\(config.minMinutes) min"
        }
        return "\(config.minMinutes)-\(config.maxMinutes) min"
    }
    
    private var questRank: String {
        QuestRankResolver.rank(for: template, instance: instance)
    }
    
    private var xpLoss: Int {
        Int(Double(instance.xpReward) * 0.5)
    }

    private var xpReward: Int {
        Int(questEngine.awardedXP(for: instance))
    }
    
    private var affectedStats: String {
        var stats = [String]()
        if let primary = instance.primaryStat {
            stats.append(primary.capitalized)
        }
        stats.append(contentsOf: instance.secondaryStatsArray.map { $0.trimmingCharacters(in: .whitespaces).capitalized })
        return stats.joined(separator: ", ")
    }
    
    private func editNotes() {
        notesText = instance.notes ?? ""
        showingNotesEditor = true
    }
    
    private func acceptQuest() {
        onAccept?(instance)
        presentationMode.wrappedValue.dismiss()
    }
    private func completeQuest() {
        onComplete?(instance)
        presentationMode.wrappedValue.dismiss()
    }
    private func failQuest() {
        onFail?(instance)
        presentationMode.wrappedValue.dismiss()
    }
}
