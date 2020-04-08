//
//  Regions.swift
//  CountiesModel iOS
//
//  Created by Stephen Anthony on 07/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import Foundation

/// Represents a set of regions within a country.
public struct Regions: Codable {
    
    /// The regions of the United Kingdom.
    public static let unitedKingdom = try! JSONDecoder().decode(Regions.self, from: Data(contentsOf: Bundle(for: FavouritesController.self).url(forResource: "United Kingdom", withExtension: "json")!))
    
    /// The name of the Region.
    public let name: String
    
    /// The regions of a country.
    public let regions: [Region]
}

/// Represents an individual region within a country.
public struct Region: Codable {
    
    /// The name of the regions.
    public let name: String
    
    /// The counties within the region.
    public let counties: [County]
}
