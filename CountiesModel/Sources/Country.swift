//
//  Country.swift
//  CountiesModel iOS
//
//  Created by Stephen Anthony on 07/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import Foundation

/// Represents a set of regions within a country.
public struct Country: Codable {
    
    /// `Country` representation of the United Kingdom.
    public static let unitedKingdom = try! JSONDecoder().decode(Country.self, from: Data(contentsOf: Bundle(for: BundleClass.self).url(forResource: "United Kingdom", withExtension: "json")!))
    
    /// The name of the country.
    public let name: String
    
    /// The regions of the country.
    public let regions: [Region]
    
    /// Allows for a `Country`'s counties to be looked up by name.
    /// - Parameter name: The name of the county we wish to find.
    /// - Returns: The county with the given name, if any.
    public func county(forName name: String) -> County? {
        let allCounties = regions.map({ $0.counties }).reduce([], +)
        return allCounties.first(where: { $0.name == name })
    }
}

/// Represents an individual region within a country.
public struct Region: Codable {
    
    /// The name of the regions.
    public let name: String
    
    /// The counties within the region.
    public let counties: [County]
    
    /// Allows the receiver to be filtered by a given list of counties.
    /// - Parameter counties: The counties by which the receiver should be
    /// filtered.
    /// - Returns: A copy of the receiver, with a `counties` array containing
    /// only those present in the receiver's `counties` and the given `counties`
    /// array.
    fileprivate func filtered(by counties: [County]) -> Region {
        let selfCountySet = Set(self.counties)
        let filterCountySet = Set(counties)
        return Region(name: name, counties: Array(selfCountySet.intersection(filterCountySet)).sorted())
    }
}

public extension Array where Element == Region {
    
    /// Allows the receiver to be filtered by a given list of counties.
    /// - Parameter counties: The counties by which the receiver should be
    /// filtered.
    /// - Returns: A list of regions containing only those counties specified in
    /// the given `counties` array. Regions with no counties in the `counties`
    /// array are excluded.
    func filtered(by counties: [County]) -> [Region] {
        return map({ $0.filtered(by: counties) }).filter { $0.counties.isEmpty == false }
    }
}

private class BundleClass {}
