//
//  AppDelegate.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let spotlightController = SpotlightController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        spotlightController.indexCounties(County.allCounties)
        CountyHistory.shared.delegate = self
        FavouritesController.shared.synchronise()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if County.from(userActivity: options.userActivities.first) != nil {
            let countyConfiguration = UISceneConfiguration(name: "County Configuration", sessionRole: connectingSceneSession.role)
            countyConfiguration.delegateClass = CountySceneDelegate.self
            countyConfiguration.storyboard = UIStoryboard(name: "CountyViewController", bundle: nil)
            return countyConfiguration
        }
        let masterConfiguration = UISceneConfiguration(name: "Master Configuration", sessionRole: connectingSceneSession.role)
        masterConfiguration.delegateClass = MasterSceneDelegate.self
        masterConfiguration.storyboard = UIStoryboard(name: "Main", bundle: nil)
        return masterConfiguration
    }
}

// MARK: CountyHistoryDelegate
extension AppDelegate: CountyHistoryDelegate {
    func countyHistoryDidUpdate(_ countyHistory: CountyHistory) {
        UIApplication.shared.shortcutItems = countyHistory.recentlyViewedCounties.map({ (county) -> UIApplicationShortcutItem in
            let shortcutItem = UIMutableApplicationShortcutItem(type: CountyItemShortcutType, localizedTitle: county.name)
            shortcutItem.targetContentIdentifier = county.name
            return shortcutItem
        })
    }
}
