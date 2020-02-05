//
//  County+UIExtensions.swift
//  Counties
//
//  Created by Stephen Anthony on 05/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesModel

extension County {
    var populationDescription: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return "Population: " + numberFormatter.string(from: NSNumber(value: population))!
        }
    }
    
    var flagImage: UIImage? {
        get {
            return UIImage(named: name)
        }
    }
}
