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
    var window: UIWindow?
    let spotlightController = SpotlightController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        spotlightController.indexCounties(County.allCounties)
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        spotlightController.handleUserActivity(userActivity) { (county) -> Void in
            if let county = county {
                let navigationController = window?.rootViewController as! UINavigationController
                navigationController.dismissViewControllerAnimated(false, completion: nil)
                let viewController = navigationController.topViewController as! ViewController
                viewController.showCounty(county, animated: false)
            }
        }
        return true
    }
}

