//
//  AppDelegate.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesUI
import CountiesModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let spotlightController = SpotlightController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        spotlightController.indexCounties(County.allCounties)
        NotificationCenter.default.addObserver(self, selector: #selector(updateApplicationShortcutItems(_:)),
                                               name: CountyHistory.countyHistoryDidUpdateNotification,
                                               object: CountyHistory.shared)
        FavouritesController.shared.synchronise()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if Country.unitedKingdom.countyFrom(userActivity: options.userActivities.first) != nil {
            let countyConfiguration = UISceneConfiguration(name: "County Configuration", sessionRole: connectingSceneSession.role)
            countyConfiguration.delegateClass = CountySceneDelegate.self
            countyConfiguration.storyboard = UIStoryboard.countyViewControllerStoryboard
            return countyConfiguration
        }
        let masterConfiguration = UISceneConfiguration(name: "Master Configuration", sessionRole: connectingSceneSession.role)
        masterConfiguration.delegateClass = MasterSceneDelegate.self
        masterConfiguration.storyboard = UIStoryboard(name: "Main", bundle: nil)
        return masterConfiguration
    }
    
    @objc private func updateApplicationShortcutItems(_ notification: Notification) {
        UIApplication.shared.shortcutItems = (notification.object as! CountyHistory).recentlyViewedCounties.map({ (county) -> UIApplicationShortcutItem in
            let shortcutItem = UIMutableApplicationShortcutItem(type: CountyItemShortcutType, localizedTitle: county.name)
            shortcutItem.targetContentIdentifier = county.name
            return shortcutItem
        })
    }
}
