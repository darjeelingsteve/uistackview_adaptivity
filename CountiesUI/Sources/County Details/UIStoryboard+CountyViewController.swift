//
//  UIStoryboard+CountyViewController.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 05/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /// The storyboard containing a `CountyViewController`.
    public static var countyViewControllerStoryboard: UIStoryboard {
        return UIStoryboard(name: "CountyViewController", bundle: Bundle.countiesUIBundle)
    }
}
