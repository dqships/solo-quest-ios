//
//  KeyboardDismissTapGestureHostView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import UIKit

final class KeyboardDismissTapGestureHostView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
