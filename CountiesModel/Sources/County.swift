//
//  County.swift
//  CountiesModel
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/*!
The struct used to represent an individual county.
*/
public struct County: Codable, Hashable {
    public let name: String
    public let population: Population
    public var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    public let url: URL
    private let latitude: Double
    private let longitude: Double
    
    /// Models the population data for a county.
    public struct Population: Codable, Hashable {
        public let total: Int
        public let year: Int
        public let source: URL
    }
}

extension County: Comparable {
    public static func < (lhs: County, rhs: County) -> Bool {
        return lhs.name < rhs.name
    }
}

extension County {
    public var populationDescription: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return String(format: NSLocalizedString("Population: %@", comment: "County population label text"), numberFormatter.string(from: NSNumber(value: population.total))!)
    }
    
    public var flagImage: UIImage? {
        return UIImage(named: name, in: Bundle.countiesModelBundle, with: nil)
    }
    
    @available(iOS 13.0, tvOS 13.0, *)
    @available(watchOS, unavailable)
    public var flagImageThumbnail: UIImage? {
        return UIImage(named: "Thumbnails/\(name)", in: Bundle.countiesModelBundle, with: nil)
    }
}
