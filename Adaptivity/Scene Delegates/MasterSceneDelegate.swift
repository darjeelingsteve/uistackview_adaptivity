//
//  MasterSceneDelegate.swift
//  Counties
//
//  Created by Stephen Anthony on 18/12/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit

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
            let countiesViewController = CountiesViewController()
            let navigationController = UINavigationController(rootViewController: countiesViewController)
            navigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("All Counties", comment: "All counties tab bar item title"), image: UIImage(systemName: "list.bullet"), selectedImage: nil)
            tabBarController.addChild(navigationController)
            applicationShortcutHandler = ApplicationShortcutHandler(countiesViewController: countiesViewController)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        var handled = false
        // Loop over our user activity handlers to handle the activity
        for userActivityHandler in userActivityHandlers {
            userActivityHandler.handleUserActivity(userActivity, completionHandler: { (result) -> Void in
                handled = true
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
        dismissExistingCountyViewIfRequired { [unowned self] (_) -> (Void) in
            self.applicationShortcutHandler?.handle(shortcutItem, completionHandler: completionHandler)
        }
    }
    
    private func dismissExistingCountyViewIfRequired(_ completion: (CountiesViewController) -> (Void)) {
        let navigationController = (window?.rootViewController as! UITabBarController).children.first as! UINavigationController
        // Dismiss any existing county that is being shown
        navigationController.dismiss(animated: false, completion: nil)
        let viewController = navigationController.topViewController as! CountiesViewController
        completion(viewController)
    }
}
