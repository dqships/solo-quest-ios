//
//  AccountScope.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//
import Foundation

struct AccountScope: Equatable {
    let writeOwnerID: String
    let readOwnerIDs: Set<String>

    init(ownerID: String) {
        self.init(writeOwnerID: ownerID, readOwnerIDs: [ownerID])
    }

    init(writeOwnerID: String, readOwnerIDs: Set<String>) {
        self.writeOwnerID = writeOwnerID
        self.readOwnerIDs = readOwnerIDs.union([writeOwnerID])
    }

    var ownerID: String { writeOwnerID }
}
