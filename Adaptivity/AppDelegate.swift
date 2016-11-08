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
    let userActivityHandlers: [UserActivityHandling]
    private let history = CountyHistory()
    private var applicationShortcutHandler: ApplicationShortcutHandler?
    
    override init() {
        userActivityHandlers = [spotlightController, HandoffController()]
        super.init()
        history.delegate = self
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        spotlightController.indexCounties(County.allCounties)
        if let navigationController = window?.rootViewController as? UINavigationController, let masterViewController = navigationController.topViewController as? MasterViewController {
            masterViewController.history = history
            applicationShortcutHandler = ApplicationShortcutHandler(masterViewController: masterViewController)
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        var handled = false
        // Loop over our user activity handlers to handle the activity
        for userActivityHandler in userActivityHandlers {
            handled = userActivityHandler.handleUserActivity(userActivity, completionHandler: { (result) -> Void in
                dismissExistingCountyViewIfRequired({ (masterViewController) -> (Void) in
                    switch result {
                    case .county(let county):
                        masterViewController.showCounty(county, animated: true)
                    case .searchText(_):
                        break
                    }
                })
            })
            if handled {
                // The user activity was handled so we don't need to query any more activity handlers
                break
            }
        }
        
        return handled
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        dismissExistingCountyViewIfRequired { [unowned self] (masterViewController) -> (Void) in
            self.applicationShortcutHandler?.handle(shortcutItem, completionHandler: completionHandler)
        }
    }
    
    private func dismissExistingCountyViewIfRequired(_ completion: (MasterViewController) -> (Void)) {
        let navigationController = window?.rootViewController as! UINavigationController
        // Dismiss any existing county that is being shown
        navigationController.dismiss(animated: false, completion: nil)
        let viewController = navigationController.topViewController as! MasterViewController
        completion(viewController)
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

