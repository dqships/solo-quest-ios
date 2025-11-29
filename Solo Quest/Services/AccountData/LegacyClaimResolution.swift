// Created by DaQuan Louden on 08-25-2026
import Foundation

enum LegacyClaimResolution: Equatable {
    case unclaimed
    case claimed(String)
    case conflict
}
