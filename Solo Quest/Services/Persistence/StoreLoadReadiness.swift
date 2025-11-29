//
//  StoreLoadReadiness.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

final class StoreLoadReadiness: @unchecked Sendable {
    private let lock = NSLock()
    private var result: Result<Void, Error>?
    private var continuations: [CheckedContinuation<Void, Error>] = []

    func wait() async throws {
        try await withCheckedThrowingContinuation { continuation in
            lock.lock(); defer { lock.unlock() }
            if let result { continuation.resume(with: result) }
            else { continuations.append(continuation) }
        }
    }

    func finish(_ result: Result<Void, Error>) {
        lock.lock(); self.result = result; let pending = continuations; continuations.removeAll(); lock.unlock()
        pending.forEach { $0.resume(with: result) }
    }
}
