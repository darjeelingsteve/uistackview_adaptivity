//
//  ApplicationShortcutHandler.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 03/03/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

class ApplicationShortcutHandler: NSObject {
    private let masterViewController: MasterViewController
    
    init(masterViewController: MasterViewController) {
        self.masterViewController = masterViewController
    }
    
    func handleApplicationShortcutItem(applicationShortcutItem: UIApplicationShortcutItem) {
        if applicationShortcutItem.type == "Search" {
            masterViewController.beginSearch()
        }
        else {
            masterViewController.showCounty(County.allCounties.filter({$0.name == applicationShortcutItem.localizedTitle}).first!, animated: true)
        }
    }
}
