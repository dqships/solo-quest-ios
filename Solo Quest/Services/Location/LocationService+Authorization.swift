//
//  LocationService+Authorization.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-03-2026
//

import CoreLocation
import Foundation

extension LocationService {
    func requestAuthorizationAndLocation(timeoutSeconds: UInt64) async -> QuestLocationContext {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            startTimeout(seconds: timeoutSeconds)
            manager.requestWhenInUseAuthorization()
        }
    }

    func requestCurrentLocation(timeoutSeconds: UInt64) async -> QuestLocationContext {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            startTimeout(seconds: timeoutSeconds)
            manager.requestLocation()
        }
    }

    func startTimeout(seconds: UInt64) {
        timeoutTask?.cancel()
        timeoutTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: seconds * 1_000_000_000)
            await MainActor.run {
                self?.resume(with: self?.latestContext ?? self?.contextWithoutCoordinates(status: self?.authorizationState ?? .unknown))
            }
        }
    }

    func resume(with context: QuestLocationContext?) {
        if let context {
            latestContext = context
        }

        guard let continuation else { return }

        self.continuation = nil
        timeoutTask?.cancel()
        timeoutTask = nil

        if let context {
            continuation.resume(returning: context)
        } else {
            let fallback = contextWithoutCoordinates(status: authorizationState)
            latestContext = fallback
            continuation.resume(returning: fallback)
        }
    }
}
