//
//  County.swift
//  CountiesModel
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import Foundation
import UIKit

/*!
The struct used to represent an individual county.
*/
public struct County: Hashable {
    public let name: String
    public let population: Int
    public let latitude: Double
    public let longitude: Double
    public let url: URL
    
    /// All of the counties available to the application.
    public static var allCounties: [County] = {
        let countyDictionaries = NSArray(contentsOf: Bundle.countiesModelBundle.url(forResource: "Counties", withExtension: "plist")!) as! Array<Dictionary<String, AnyObject>>
        return countyDictionaries.map { (countryDictionary) -> County in
            return County(name: countryDictionary["name"] as! String, population: countryDictionary["population"] as! Int, latitude: countryDictionary["latitude"] as! Double, longitude: countryDictionary["longitude"] as! Double, url: URL.init(string: countryDictionary["url"] as! String)!)
        }
    }()
    
    public static func countyForName(_ name: String) -> County? {
        return allCounties.filter({$0.name == name}).first
    }
}

extension County: Comparable {
    public static func < (lhs: County, rhs: County) -> Bool {
        return lhs.name < rhs.name
    }
}

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
            return UIImage(named: name, in: Bundle.countiesModelBundle, with: nil)
        }
    }
}
