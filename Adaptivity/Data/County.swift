//
//  County.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import Foundation
import UIKit

func ==(lhs: County, rhs: County) -> Bool {
    return lhs.name == rhs.name && lhs.population == rhs.population
}

/*!
The struct used to represent an individual county.
*/
struct County : Equatable {
    let name: String
    let population: Int
    let latitude: Double
    let longitude: Double
    
    /// All of the counties available to the application.
    static var allCounties: [County] = {
        let countyDictionaries = NSArray.init(contentsOfURL: NSBundle.mainBundle().URLForResource("Counties", withExtension: "plist")!) as! Array<Dictionary<String, AnyObject>>
        return countyDictionaries.map { (countryDictionary) -> County in
            return County.init(name: countryDictionary["name"] as! String, population: countryDictionary["population"] as! Int, latitude: countryDictionary["latitude"] as! Double, longitude: countryDictionary["longitude"] as! Double)
        }
    }()
}

extension County {
    var populationDescription: String {
        get {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .DecimalStyle
            return "Population: " + numberFormatter.stringFromNumber(self.population)!
        }
    }
    
    var flagImage: UIImage? {
        get {
            return UIImage(named: self.name)
        }
    }
}
