//
//  AppUpdateGateViewModel.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Factory
import Foundation
import Combine

@MainActor
final class AppUpdateGateViewModel: ObservableObject {
    @Injected(\.appUpdateService) var appUpdateService

    @Published var hasCompletedInitialCheck = false
    @Published var requiredUpdate: AppUpdateInfo?

    var isCheckingForUpdate = false
}
