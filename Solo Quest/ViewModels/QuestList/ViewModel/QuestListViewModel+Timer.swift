//
//  QuestListViewModel+Timer.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Combine
import Foundation

extension QuestListViewModel {
    func startTimer() {
        timerCancellable = Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    self?.checkDailyReset()
                    self?.questEngine.updateQuestStates()
                }
            }
    }
}
