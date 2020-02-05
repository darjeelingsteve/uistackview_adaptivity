//
//  Bundle+Extensions.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 05/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// The `Bundle` of the `CountiesUI` framework.
    static var countiesUIBundle: Bundle {
        return Bundle(for: CountyViewController.self)
    }
}
