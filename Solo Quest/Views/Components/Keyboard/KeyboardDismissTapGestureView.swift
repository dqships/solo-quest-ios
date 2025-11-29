//
//  KeyboardDismissTapGestureView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import SwiftUI

struct KeyboardDismissTapGestureView: UIViewRepresentable {
    func makeCoordinator() -> KeyboardDismissTapGestureCoordinator {
        KeyboardDismissTapGestureCoordinator()
    }

    func makeUIView(context: Context) -> KeyboardDismissTapGestureHostView {
        KeyboardDismissTapGestureHostView()
    }

    func updateUIView(_ uiView: KeyboardDismissTapGestureHostView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.install(on: uiView)
        }
    }
}
