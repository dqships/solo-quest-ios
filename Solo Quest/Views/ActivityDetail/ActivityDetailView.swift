//
//  ActivityDetailView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import CoreData
import Factory

struct ActivityDetailView: View {
    let activityItem: ActivityLogItem
    
    @FetchRequest private var quests: FetchedResults<QuestInstance>
    @Injected(\.questEngine) private var questEngine
    
    init(activityItem: ActivityLogItem) {
        self.activityItem = activityItem
        
        if let questId = activityItem.questId, let uuid = UUID(uuidString: questId) {
            let scope = Container.shared.accountScopeProvider().activeScope
            _quests = FetchRequest(
                entity: QuestInstance.entity(),
                sortDescriptors: [],
                predicate: accountScopedPredicate(NSPredicate(format: "id == %@", uuid as CVarArg), scope: scope)
            )
        } else {
            _quests = FetchRequest(
                entity: QuestInstance.entity(),
                sortDescriptors: [],
                predicate: NSPredicate(value: false)
            )
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ActivityDetailHeaderSection(activityItem: activityItem)
                
                if let quest = quests.first {
                    let template = quest.questTemplateId.flatMap { questEngine.getTemplate(id: $0) }
                    let title = questEngine.getLocalizedDisplayTitle(for: quest, template: template)
                    
                    ActivityDetailQuestInfoSection(title: title)
                    ActivityDetailQuestStatsSection(quest: quest)
                    ActivityDetailMediaSection(quest: quest)
                    
                    if let notes = quest.notes, !notes.isEmpty {
                        ActivityDetailNotesSection(title: String(localized: "Notes"), content: notes)
                    } else if !activityItem.note.isEmpty {
                        ActivityDetailNotesSection(title: String(localized: "Activity Note"), content: activityItem.localizedNote)
                    }
                } else {
                    ActivityDetailUnavailableSection()
                    
                    if !activityItem.note.isEmpty {
                        ActivityDetailNotesSection(title: String(localized: "Activity Note"), content: activityItem.localizedNote)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Activity Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.brandBackground.ignoresSafeArea())
    }
}
