//
//  CountySceneDelegate.swift
//  Counties
//
//  Created by Stephen Anthony on 18/12/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesUI
import CountiesModel

/// The delegate of the scene used to show an individual county's details.
class CountySceneDelegate: UIResponder {
    var window: UIWindow?
}

// MARK: UIWindowSceneDelegate
extension CountySceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        scene.activationConditions.canActivateForTargetContentIdentifierPredicate = NSPredicate(value: false)
        guard let county = Country.unitedKingdom.countyFrom(userActivity: session.stateRestorationActivity ?? connectionOptions.userActivities.first),
            let countyViewController = window?.rootViewController as? CountyViewController else { return }
        countyViewController.county = county
        countyViewController.delegate = self
        scene.title = county.name
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}

// MARK: CountyViewControllerDelegate
extension CountySceneDelegate: CountyViewControllerDelegate {
    func countyViewControllerDidFinish(_ countyViewController: CountyViewController) {
        guard let sceneSession = countyViewController.view.window?.windowScene?.session else { return }
        UIApplication.shared.requestSceneSessionDestruction(sceneSession, options: nil, errorHandler: nil)
    }
}
