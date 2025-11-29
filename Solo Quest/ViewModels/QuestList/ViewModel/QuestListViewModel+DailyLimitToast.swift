//
//  QuestListViewModel+DailyLimitToast.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-24-2026
//

import Foundation
import SwiftUI

extension QuestListViewModel {
    func presentDailyLimitToast() {
        showToast = true
        toastMessage = String(localized: "Quest limit reached. Use Rerolls or get a Guild Pass.")
        toastActionTitle = String(localized: "Get Guild Pass")
        toastAction = { [weak self] in
            self?.openStoreSheet = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            withAnimation {
                self?.showToast = false
            }
        }
    }
}
