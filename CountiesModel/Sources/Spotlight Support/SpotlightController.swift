//
//  SpotlightController.swift
//  CountiesModel
//
//  Created by Stephen Anthony on 25/01/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

/// The class responsible for managing the Spotlight index for Counties.
public class SpotlightController {
    
    public init() {}
    
    /// Adds the counties of the given regions to the spotlight index.
    /// - Parameter regions: The regions whose counties we wish to index.
    public func indexRegions(_ regions: [Region]) {
        guard CSSearchableIndex.isIndexingAvailable() else {
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            let searchableItems = regions.map({ $0.counties }).reduce([], +).map { (county) -> CSSearchableItem in
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                attributeSet.title = county.name
                attributeSet.contentDescription = county.populationDescription
                attributeSet.latitude = county.location.latitude as NSNumber?
                attributeSet.longitude = county.location.longitude as NSNumber?
                attributeSet.supportsNavigation = 1
                autoreleasepool {
                    // Scale image as recommended by https://developer.apple.com/library/ios/documentation/General/Conceptual/AppSearch/SearchUserExperience.html#//apple_ref/doc/uid/TP40016308-CH11-SW1
                    if let countyFlag = county.flagImageThumbnail?.resized(toFit: CGSize(width: 300, height: 300)) {
                        attributeSet.thumbnailData = countyFlag.pngData()
                    }
                }
                let searchableItem = CSSearchableItem(uniqueIdentifier: county.name, domainIdentifier: nil, attributeSet: attributeSet)
                return searchableItem
            }

            let searchableIndex = CSSearchableIndex.default()
            searchableIndex.indexSearchableItems(searchableItems) { (error) -> Void in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
