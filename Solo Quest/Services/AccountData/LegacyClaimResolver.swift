// Created by DaQuan Louden on 08-25-2026
import Foundation

func resolveLegacyClaims(_ claims: [LegacyDatasetClaim]) -> LegacyClaimResolution {
    let owners = Set(claims.compactMap(\.claimantOwnerID))
    if owners.isEmpty { return .unclaimed }
    if let owner = owners.first, owners.count == 1 { return .claimed(owner) }
    return .conflict
}
