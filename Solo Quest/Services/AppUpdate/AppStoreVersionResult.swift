//
//  AppStoreVersionResult.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Foundation

struct AppStoreVersionResult: Decodable {
    let version: String
    let releaseNotes: String?
    let trackViewUrl: String?
    let trackId: Int?
}
