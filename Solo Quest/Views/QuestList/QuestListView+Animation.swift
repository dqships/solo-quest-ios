//
//  QuestListView+Animation.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

extension QuestListView {
    func animationType(for event: QuestListViewModel.QuestAnimationEvent) -> QuestCardAnimationView.AnimationType {
        switch event {
        case .accepted: return .accepted
        case .completed: return .completed
        case .failed: return .failed
        }
    }
}
