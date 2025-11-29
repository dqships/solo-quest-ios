//
//  AccountScope+ViewIdentity.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import Foundation

extension AccountScope {
    var viewIdentity: String {
        let sortedReadOwnerIDs = readOwnerIDs.sorted().joined(separator: ",")
        return "\(writeOwnerID)|\(sortedReadOwnerIDs)"
    }
}
