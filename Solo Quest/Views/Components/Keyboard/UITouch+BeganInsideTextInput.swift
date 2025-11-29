//
//  UITouch+BeganInsideTextInput.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import UIKit

extension UITouch {
    var beganInsideTextInput: Bool {
        var currentView = view

        while let inspectedView = currentView {
            if inspectedView is UITextField || inspectedView is UITextView {
                return true
            }

            currentView = inspectedView.superview
        }

        return false
    }
}
