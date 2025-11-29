//
//  KeyboardDismissAction.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import UIKit

enum KeyboardDismissAction {
    static func perform() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
