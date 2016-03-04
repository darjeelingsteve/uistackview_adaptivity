//
//  AppDelegate.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CountyHistoryDelegate {
    var window: UIWindow?
    let spotlightController = SpotlightController()
    let userActivityHandlers: [CountyUserActivityHandling]
    private let history = CountyHistory()
    private var applicationShortcutHandler: ApplicationShortcutHandler?
    
    override init() {
        userActivityHandlers = [spotlightController, HandoffController()]
        super.init()
        history.delegate = self
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        spotlightController.indexCounties(County.allCounties)
        if let navigationController = window?.rootViewController as? UINavigationController, masterViewController = navigationController.topViewController as? MasterViewController {
            masterViewController.history = history
            applicationShortcutHandler = ApplicationShortcutHandler(masterViewController: masterViewController)
        }
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        var handled = false
        // Loop over our user activity handlers to handle the activity
        for userActivityHandler in userActivityHandlers {
            handled = userActivityHandler.handleUserActivity(userActivity, completionHandler: { (county) -> Void in
                dismissExistingCountyViewIfRequired({ (masterViewController) -> (Void) in
                    masterViewController.showCounty(county, animated: true)
                })
            })
            if handled {
                // The user activity was handled so we don't need to query any more activity handlers
                break
            }
        }
        
        return handled
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        dismissExistingCountyViewIfRequired { [unowned self] (masterViewController) -> (Void) in
            self.applicationShortcutHandler?.handleApplicationShortcutItem(shortcutItem, completionHandler: completionHandler)
        }
    }
    
    private func dismissExistingCountyViewIfRequired(completion: (MasterViewController) -> (Void)) {
        let navigationController = window?.rootViewController as! UINavigationController
        // Dismiss any existing county that is being shown
        navigationController.dismissViewControllerAnimated(false, completion: nil)
        let viewController = navigationController.topViewController as! MasterViewController
        completion(viewController)
    }
    
    //MARK: CountyHistoryDelegate
    func countyHistoryDidUpdate(countyHistory: CountyHistory) {
        UIApplication.sharedApplication().shortcutItems = countyHistory.recentlyViewedCounties.map({ (county) -> UIApplicationShortcutItem in
            return UIApplicationShortcutItem(type: CountyItemShortcutType, localizedTitle: county.name)
        })
    }
}

