//
//  AccountScopedPredicate.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-25-2026
//

import CoreData

func accountScopedPredicate(_ predicate: NSPredicate?, scope: AccountScope) -> NSPredicate {
    let owner = accountOwnedPredicate(scope)
    guard let predicate else { return owner }
    return NSCompoundPredicate(andPredicateWithSubpredicates: [owner, predicate])
}
