//
//  View+KeyboardDismissal.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import SwiftUI

extension View {
    func keyboardDismissalEnabled() -> some View {
        modifier(KeyboardDismissalModifier())
    }
}
