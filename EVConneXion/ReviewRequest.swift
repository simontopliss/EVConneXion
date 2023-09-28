//
//  EVConneXionApp.swift
//  EVConneXion
//
//  Created by Simon Topliss on 18/09/2023.
//

import StoreKit
import SwiftUI

enum ReviewRequest {
    static var limit = 10

    @AppStorage(UserDefaultKeys.appLaunchCount) static var appLaunchCount = 0
    @AppStorage(UserDefaultKeys.version) static var version = ""

    static func showReview() {
        appLaunchCount += 1

        // swiftlint:disable:next force_cast
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        // swiftlint:disable:next force_cast
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let currentVersion = "Version \(appVersion), build \(appBuild)"

        guard currentVersion != version else { return }
        guard appLaunchCount == limit else { return }

        if let scene = UIApplication.shared.connectedScenes.first(
            where: { $0.activationState == .foregroundActive }
        ) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            appLaunchCount = 0
            version = currentVersion
        }
    }
}
