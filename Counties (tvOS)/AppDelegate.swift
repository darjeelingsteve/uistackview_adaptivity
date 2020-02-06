//
//  AppDelegate.swift
//  Counties (tvOS)
//
//  Created by Stephen Anthony on 06/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.viewControllers = [CountiesViewController(style: .allCounties), CountiesViewController(style: .favourites)]
        }
        return true
    }
}
