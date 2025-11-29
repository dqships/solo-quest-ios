//
//  KeyboardDismissTapGestureCoordinator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import UIKit

final class KeyboardDismissTapGestureCoordinator: NSObject, UIGestureRecognizerDelegate {
    private weak var attachedView: UIView?

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()

    func install(on hostView: UIView) {
        guard let parentView = hostView.superview,
              attachedView !== parentView else {
            return
        }

        attachedView?.removeGestureRecognizer(tapGestureRecognizer)
        parentView.addGestureRecognizer(tapGestureRecognizer)
        attachedView = parentView
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !touch.beganInsideTextInput
    }

    @objc private func handleTap() {
        KeyboardDismissAction.perform()
    }

    deinit {
        attachedView?.removeGestureRecognizer(tapGestureRecognizer)
    }
}
