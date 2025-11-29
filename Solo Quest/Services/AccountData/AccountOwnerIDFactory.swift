//
//  AccountOwnerIDFactory.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//
import Foundation

enum AccountOwnerIDFactory {
    static func clerk(_ id: String) -> String { "clerk:\(id)" }
    static func local(_ id: UUID) -> String { "local:\(id.uuidString)" }
    static let legacy = "legacy:quarantined:v1"
}
