//
//  CountySceneDelegate.swift
//  Counties
//
//  Created by Stephen Anthony on 18/12/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The delegate of the scene used to show an individual county's details.
class CountySceneDelegate: UIResponder {
    var window: UIWindow?
}

// MARK: UIWindowSceneDelegate
extension CountySceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let county = County.from(userActivity: session.stateRestorationActivity ?? connectionOptions.userActivities.first),
            let countyViewController = window?.rootViewController as? CountyViewController else { return }
        countyViewController.county = county
        scene.title = county.name
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}
