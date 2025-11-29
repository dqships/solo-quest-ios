//
//  AccountUserStatsSortDescriptors.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData

func accountUserStatsSortDescriptors() -> [NSSortDescriptor] {
    [
        NSSortDescriptor(key: "ownerID", ascending: false),
        NSSortDescriptor(key: "level", ascending: false),
        NSSortDescriptor(key: "profileID", ascending: true)
    ]
}
