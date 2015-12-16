//
//  County.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import Foundation

/*!
The struct used to represent an individual county.
*/
struct County {
    let name: String
    let population: Int
    
    /*!
    - parameter name:       The name of the county
    - parameter population: The population of the county.
    - returns: A new `County` with the given details.
    */
    init(withName name:String, population: Int) {
        self.name = name
        self.population = population
    }
    
    /// All of the counties available to the application.
    static var allCounties: [County] {
        get {
            let countyDictionaries = NSArray.init(contentsOfURL: NSBundle.mainBundle().URLForResource("Counties", withExtension: "plist")!) as! Array<Dictionary<String, AnyObject>>
            return countyDictionaries.map { (countryDictionary) -> County in
                return County.init(withName: countryDictionary["name"] as! String, population: countryDictionary["population"] as! Int)
            }
        }
    }
}
