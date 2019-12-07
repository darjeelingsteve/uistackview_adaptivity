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
struct County: Hashable {
    let name: String
    let population: Int
    let latitude: Double
    let longitude: Double
    let url: URL
    
    /// All of the counties available to the application.
    static var allCounties: [County] = {
        let countyDictionaries = NSArray.init(contentsOf: Bundle.main.url(forResource: "Counties", withExtension: "plist")!) as! Array<Dictionary<String, AnyObject>>
        return countyDictionaries.map { (countryDictionary) -> County in
            return County.init(name: countryDictionary["name"] as! String, population: countryDictionary["population"] as! Int, latitude: countryDictionary["latitude"] as! Double, longitude: countryDictionary["longitude"] as! Double, url: URL.init(string: countryDictionary["url"] as! String)!)
        }
    }()
    
    static func countyForName(_ name: String) -> County? {
        return allCounties.filter({$0.name == name}).first
    }
}

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
