//
//  PenaltyRefreshTestCustomerInfoFetcher.swift
//  Solo QuestTests
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation
@testable import Solo_Quest

@MainActor
final class PenaltyRefreshTestCustomerInfoFetcher: PenaltyCustomerInfoFetching {
    enum TestError: Error {
        case unavailable
    }

    private var continuations: [CheckedContinuation<Result<PenaltyCustomerInfoPayload, Error>, Never>] = []

    var pendingRequestCount: Int {
        continuations.count
    }

    func fetchCustomerInfo() async throws -> PenaltyCustomerInfoPayload {
        let result: Result<PenaltyCustomerInfoPayload, Error> = await withCheckedContinuation { continuation in
            continuations.append(continuation)
        }
        return try result.get()
    }

    func succeed(_ payload: PenaltyCustomerInfoPayload, at index: Int) {
        let continuation = continuations.remove(at: index)
        continuation.resume(returning: .success(payload))
    }

    func fail(at index: Int) {
        let continuation = continuations.remove(at: index)
        continuation.resume(returning: .failure(TestError.unavailable))
    }
}
