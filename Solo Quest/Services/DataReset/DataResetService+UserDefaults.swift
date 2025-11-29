//
//  DataResetService+UserDefaults.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import Foundation

extension DataResetService {
    func clearUserDefaults() {
        DataResetUserDefaultsKey.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
}
