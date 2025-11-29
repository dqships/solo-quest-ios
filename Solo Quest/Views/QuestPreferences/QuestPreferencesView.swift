//
//  QuestPreferencesView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Factory

struct QuestPreferencesView: View {
    @Injected(\.questEngine) private var questEngine
    @Injected(\.analyticsManager) private var analytics
    @Environment(\.dismiss) private var dismiss
    
    @State private var preferences: QuestFilterPreferences = QuestFilterPreferences()
    @State private var hasChanges: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    QuestPreferencesHeaderView()
                    
                    QuestPreferenceSectionView(
                        title: "Quest Type",
                        subtitle: "What kind of quests interest you?",
                        items: QuestCategory.allCases,
                        selectedItems: $preferences.preferredCategories,
                        onChange: markChanged
                    )
                    
                    QuestPreferenceSectionView(
                        title: "Social Level",
                        subtitle: "How social do you want your quests?",
                        items: SocialIntensity.allCases,
                        selectedItems: $preferences.preferredSocialIntensities,
                        onChange: markChanged
                    )
                    
                    QuestPreferenceSectionView(
                        title: "Energy Level",
                        subtitle: "How much energy are you willing to spend?",
                        items: EnergyLevel.allCases,
                        selectedItems: $preferences.preferredEnergyLevels,
                        onChange: markChanged
                    )
                    
                    QuestPreferenceSectionView(
                        title: "Duration",
                        subtitle: "How much time do you have?",
                        items: DurationBucket.allCases,
                        selectedItems: $preferences.preferredDurations,
                        onChange: markChanged
                    )
                    
                    QuestPreferenceSectionView(
                        title: "Location",
                        subtitle: "Where do you want your quests?",
                        items: LocationType.allCases,
                        selectedItems: $preferences.preferredLocationTypes,
                        onChange: markChanged
                    )
                    
                    QuestPreferenceSectionView(
                        title: "Budget",
                        subtitle: "How much are you willing to spend?",
                        items: CostLevel.allCases,
                        selectedItems: $preferences.preferredCostLevels,
                        onChange: markChanged
                    )
                    
                    QuestPreferenceSectionView(
                        title: "Time of Day",
                        subtitle: "When do you usually play?",
                        items: TimeOfDay.allCases,
                        selectedItems: $preferences.preferredTimeOfDay,
                        onChange: markChanged
                    )
                    
                    QuestPreferenceSectionView(
                        title: "Comfort Zone",
                        subtitle: "How far do you want to push yourself?",
                        items: ComfortZone.allCases,
                        selectedItems: $preferences.preferredComfortZones,
                        onChange: markChanged
                    )
                    
                    if preferences.hasAnyPreferences {
                        QuestPreferencesResetButton {
                            withAnimation(.spring(response: 0.3)) {
                                preferences = QuestFilterPreferences()
                                hasChanges = true
                            }
                        }
                    }
                    
                    QuestPreferencesInfoView()
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color.brandBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.brandDarkText)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let didChange = preferences != questEngine.getFilterPreferences()
                        questEngine.updateFilterPreferences(preferences)
                        if didChange {
                            questEngine.refreshAvailableDailyQuestsForPreferences()
                        }
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.brandBrownRich)
                }
            }
        }
        .onAppear {
            preferences = questEngine.getFilterPreferences()
            analytics.track(
                event: "quest_preferences_opened",
                properties: preferences.analyticsProperties.merging([
                    "source": "quest_list"
                ], uniquingKeysWith: { _, new in new })
            )
        }
    }
    
    private func markChanged() {
        hasChanges = true
    }
}
