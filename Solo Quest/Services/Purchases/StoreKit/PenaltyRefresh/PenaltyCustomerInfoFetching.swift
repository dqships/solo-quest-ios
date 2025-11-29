//
//  PenaltyCustomerInfoFetching.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//
//

import Foundation

@MainActor
protocol PenaltyCustomerInfoFetching {
    func fetchCustomerInfo() async throws -> PenaltyCustomerInfoPayload
}
