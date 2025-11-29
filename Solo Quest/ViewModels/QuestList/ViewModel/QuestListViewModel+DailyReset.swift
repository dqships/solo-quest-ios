//
//  QuestListViewModel+DailyReset.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Foundation

extension QuestListViewModel {
    func checkDailyReset() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let outcome = await questEngine.checkDailyReset()
            presentDailyResetOutcome(outcome)
        }
    }

    private func presentDailyResetOutcome(_ outcome: DailyResetOutcome) {
        guard let penalty = outcome.dailySkipPenaltyXP, penalty > 0 else { return }

        activeModal = .dailySkip(penalty: penalty)
    }
}
