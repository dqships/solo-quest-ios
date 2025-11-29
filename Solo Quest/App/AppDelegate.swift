//
//  AppDelegate.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 12-04-2025.
//  Modified by DaQuan Louden on 11-03-2026
//

import Foundation
import PostHog
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        guard !AppRuntimeMode.isRunningXCTest else { return true }
        guard let postHogAPIKey = ConfiguredInfoValue.string(forKey: "PostHogAPIKey") else { return true }

        let config = PostHogConfig(projectToken: postHogAPIKey, host: "https://us.i.posthog.com")
        config.sessionReplay = false
        PostHogSDK.shared.setup(config)

        return true
    }
}
