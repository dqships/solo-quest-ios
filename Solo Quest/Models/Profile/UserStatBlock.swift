//
//  UserStatBlock.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

struct UserStatBlock: Codable, Equatable, Hashable {
    let luck: Int
    let charisma: Int
    let strength: Int
    let stamina: Int
    let resilience: Int
    let intelligence: Int
}
