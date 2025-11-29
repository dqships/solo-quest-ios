//
//  RerollReason.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Foundation

enum RerollReason: String, CaseIterable, Identifiable {
    case tooMuchTime = "too_much_time"
    case tooMuchEnergy = "too_much_energy"
    case tooSocial = "too_social"
    case cannotDoItHere = "cannot_do_it_here"
    case costsMoney = "costs_money"
    case notInterested = "not_interested"
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tooMuchTime: return String(localized: "Too much time")
        case .tooMuchEnergy: return String(localized: "Too much energy")
        case .tooSocial: return String(localized: "Too social")
        case .cannotDoItHere: return String(localized: "Can't do it here")
        case .costsMoney: return String(localized: "Costs money")
        case .notInterested: return String(localized: "Not interested")
        case .other: return String(localized: "Other")
        }
    }
}
