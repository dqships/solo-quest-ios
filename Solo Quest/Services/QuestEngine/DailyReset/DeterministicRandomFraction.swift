//
//  DeterministicRandomFraction.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CryptoKit
import Foundation

enum DeterministicRandomFraction {
    static func make(seed: String, purpose: String, index: Int) -> Double {
        let source = "\(seed)|\(purpose)|\(index)"
        let digest = SHA256.hash(data: Data(source.utf8))
        let value = digest.prefix(8).reduce(UInt64.zero) { partialResult, byte in
            (partialResult << 8) | UInt64(byte)
        }
        let significand = value >> 11
        return Double(significand) / 9_007_199_254_740_992.0
    }
}
