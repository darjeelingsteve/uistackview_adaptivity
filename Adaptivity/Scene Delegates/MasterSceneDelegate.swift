//
//  MasterSceneDelegate.swift
//  Counties
//
//  Created by Stephen Anthony on 18/12/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesUI
import CountiesModel

/// The delegate of the application's master scene.
class MasterSceneDelegate: UIResponder {
    var window: UIWindow?
    private let spotlightController = SpotlightController()
    private var applicationShortcutHandler: ApplicationShortcutHandler?
    private let userActivityHandlers: [UserActivityHandling]
    
    override init() {
        userActivityHandlers = [spotlightController, HandoffController(), SpotlightQueryContinuationHandler()]
        super.init()
    }
}

// MARK: UIWindowSceneDelegate
extension MasterSceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let allCountiesViewController = CountiesViewController(style: .allCounties)
            let favouriteCountiesViewController = CountiesViewController(style: .favourites)
            tabBarController.viewControllers = [UINavigationController(rootViewController: allCountiesViewController), UINavigationController(rootViewController: favouriteCountiesViewController)]
            applicationShortcutHandler = ApplicationShortcutHandler(countiesViewController: allCountiesViewController)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        var handled = false
        // Loop over our user activity handlers to handle the activity
        for userActivityHandler in userActivityHandlers {
            userActivityHandler.handleUserActivity(userActivity, completionHandler: { (result) -> Void in
                handled = true
                switchToAllCountiesTab()
                dismissExistingCountyViewIfRequired({ (countiesViewController) -> (Void) in
                    switch result {
                    case .county(let county):
                        countiesViewController.showCounty(county, animated: false)
                    case .searchText(let searchText):
                        countiesViewController.beginSearch(withText: searchText)
                    }
                })
            })
            if handled {
                // The user activity was handled so we don't need to query any more activity handlers
                break
            }
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switchToAllCountiesTab()
        dismissExistingCountyViewIfRequired { [unowned self] (_) -> (Void) in
            self.applicationShortcutHandler?.handle(shortcutItem, completionHandler: completionHandler)
        }
    }
    
    private func switchToAllCountiesTab() {
        guard let tabBarController = window?.rootViewController as? UITabBarController else { return }
        tabBarController.selectedIndex = 0
    }
    
    private func dismissExistingCountyViewIfRequired(_ completion: (CountiesViewController) -> (Void)) {
        let navigationController = (window?.rootViewController as! UITabBarController).children.first as! UINavigationController
        // Dismiss any existing county that is being shown
        navigationController.dismiss(animated: false, completion: nil)
        let viewController = navigationController.topViewController as! CountiesViewController
        completion(viewController)
    }
}
