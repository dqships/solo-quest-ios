//
//  Color+Palette.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import UIKit

extension Color {
    /// White background (Light) -> Dark charcoal (Dark)
    static let brandBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "1C1C1E")
            : UIColor(hex: "FFFFFF")
    })

    /// Secondary panel gray (Light) -> Darker panel (Dark)
    static let brandPanelDark = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "3A3A3C")
            : UIColor(hex: "ABBDC6")
    })

    /// Neutral gray (remains similar for both modes)
    static let brandNeutral = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "8E8E93")
            : UIColor(hex: "9AA3A8")
    })

    /// Dark text/outline (Light) -> Light text (Dark)
    static let brandDarkText = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "F2F2F7")
            : UIColor(hex: "291F23")
    })

    /// Deep brown (outer cloak shadow)
    static let brandBrownDeep = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "6B3D2B")
            : UIColor(hex: "583022")
    })

    /// Rich brown (belt / outlines)
    static let brandBrownRich = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "9A6545")
            : UIColor(hex: "73452F")
    })

    /// Mid brown (cloak midtone)
    static let brandBrownMid = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "B06840")
            : UIColor(hex: "925331")
    })

    /// Warm brown-orange (cloak highlight)
    static let brandBrownHighlight = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "D8905A")
            : UIColor(hex: "C97B44")
    })

    /// Skin tone
    static let brandSkin = Color(hex: "FBC396")

    /// Orange accent (star badge, bars)
    static let brandAccentOrange = Color(hex: "E2935A")

    /// Dark blue-gray (HUD text, bars) -> Lighter for dark mode
    static let brandTextSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "A0A0A5")
            : UIColor(hex: "57636D")
    })

    /// Card surface background
    static let brandCardSurface = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "2C2C2E")
            : UIColor.white
    })

    /// Elevated surface (modals, sheets)
    static let brandElevatedSurface = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "3A3A3C")
            : UIColor.white
    })
}
