//
//  AppDelegate.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        CountyHistory.shared.delegate = self
        return true
    }
}

// MARK: CountyHistoryDelegate
extension AppDelegate: CountyHistoryDelegate {
    func countyHistoryDidUpdate(_ countyHistory: CountyHistory) {
        UIApplication.shared.shortcutItems = countyHistory.recentlyViewedCounties.map({ (county) -> UIApplicationShortcutItem in
            return UIApplicationShortcutItem(type: CountyItemShortcutType, localizedTitle: county.name)
        })
    }
}
