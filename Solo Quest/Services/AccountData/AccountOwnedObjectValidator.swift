//
//  AccountOwnedObjectValidator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData

func isOwnedByActiveAccount(_ object: NSManagedObject, scope: AccountScope) -> Bool {
    guard let ownerID = object.value(forKey: "ownerID") as? String else {
        return false
    }
    return scope.readOwnerIDs.contains(ownerID)
}
