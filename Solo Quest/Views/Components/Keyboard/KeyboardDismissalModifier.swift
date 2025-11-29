//
//  KeyboardDismissalModifier.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import SwiftUI

struct KeyboardDismissalModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollDismissesKeyboard(.interactively)
            .background(KeyboardDismissTapGestureView())
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        KeyboardDismissAction.perform()
                    }
                }
            }
    }
}
