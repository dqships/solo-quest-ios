//
//  AppStoreLookupResponse.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import Foundation

struct AppStoreLookupResponse: Decodable {
    let results: [AppStoreVersionResult]
}
