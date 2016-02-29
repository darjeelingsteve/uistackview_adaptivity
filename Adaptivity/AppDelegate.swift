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
    let userActivityHandlers: [CountyUserActivityHandling]
    
    override init() {
        userActivityHandlers = [spotlightController, HandoffController()]
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        spotlightController.indexCounties(County.allCounties)
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        var handled = false
        // Loop over our user activity handlers to handle the activity
        for userActivityHandler in userActivityHandlers {
            handled = userActivityHandler.handleUserActivity(userActivity, completionHandler: { (county) -> Void in
                showCounty(county)
            })
            if handled {
                // The user activity was handled so we don't need to query any more activity handlers
                break
            }
        }
        
        return handled
    }
    
    private func showCounty(county: County) {
        let navigationController = window?.rootViewController as! UINavigationController
        // Dismiss any existing county that is being shown
        navigationController.dismissViewControllerAnimated(false, completion: nil)
        let viewController = navigationController.topViewController as! MasterViewController
        viewController.showCounty(county, animated: false)
    }
}

