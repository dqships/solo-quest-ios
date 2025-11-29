//
//  StoreViewModel+Observers.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Combine
import Foundation

extension StoreViewModel {
    func setupObservers() {
        storeKit.$isPro
            .receive(on: RunLoop.main)
            .assign(to: \.isPro, on: self)
            .store(in: &cancellables)
    }
}
