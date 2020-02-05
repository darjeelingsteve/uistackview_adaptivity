//
//  County+UIExtensions.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 05/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesModel

extension County {
    public var populationDescription: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return "Population: " + numberFormatter.string(from: NSNumber(value: population))!
        }
    }
    
    public var flagImage: UIImage? {
        get {
            return UIImage(named: name, in: County.frameworkBundle, with: nil)
        }
    }
    
    private static var frameworkBundle: Bundle {
        #if os(iOS)
        return Bundle(identifier: "com.darjeeling.CountiesUI-iOS")!
        #elseif os(watchOS)
        return Bundle(identifier: "com.darjeeling.CountiesUI-watchOS")!
        #endif
    }
}

