// Created by DaQuan Louden on 08-25-2026
import CoreData

func accountOwnedPredicate(_ scope: AccountScope) -> NSPredicate {
    NSPredicate(format: "ownerID IN %@", Array(scope.readOwnerIDs))
}
