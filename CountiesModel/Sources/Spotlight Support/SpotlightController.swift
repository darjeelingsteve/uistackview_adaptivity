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
    
    public func indexCounties(_ counties: [County]) {
        guard CSSearchableIndex.isIndexingAvailable() else {
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            let searchableItems = counties.map { (county) -> CSSearchableItem in
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                attributeSet.title = county.name
                attributeSet.contentDescription = county.populationDescription
                attributeSet.latitude = county.location.latitude as NSNumber?
                attributeSet.longitude = county.location.longitude as NSNumber?
                attributeSet.supportsNavigation = 1
                if let countyFlag = county.flagImage {
                    attributeSet.thumbnailData = countyFlag.pngData()
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
