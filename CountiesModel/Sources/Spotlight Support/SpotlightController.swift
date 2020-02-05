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

private let SpotlightControllerHasIndexedKey = "HasIndexed"

/// The class responsible for managing the Spotlight index for Counties.
public class SpotlightController {
    
    public init() {}
    
    public func indexCounties(_ counties: [County]) {
        guard CSSearchableIndex.isIndexingAvailable() == true && UserDefaults.standard.bool(forKey: SpotlightControllerHasIndexedKey) == false else {
            // We either can't index or don't need to
            return
        }
        
        let searchableItems = counties.map { (county) -> CSSearchableItem in
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
            attributeSet.title = county.name
            attributeSet.contentDescription = county.populationDescription
            attributeSet.latitude = county.latitude as NSNumber?
            attributeSet.longitude = county.longitude as NSNumber?
            attributeSet.supportsNavigation = 1
            if let countyFlag = county.flagImage {
                // Scale image as recommended by https://developer.apple.com/library/ios/documentation/General/Conceptual/AppSearch/SearchUserExperience.html#//apple_ref/doc/uid/TP40016308-CH11-SW1
                attributeSet.thumbnailData = countyFlag.scaledImageWithWidth(300).pngData()
            }
            let searchableItem = CSSearchableItem(uniqueIdentifier: county.name, domainIdentifier: nil, attributeSet: attributeSet)
            return searchableItem
        }
        
        let searchableIndex = CSSearchableIndex.default()
        searchableIndex.indexSearchableItems(searchableItems) { (error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            else {
                UserDefaults.standard.set(true, forKey: SpotlightControllerHasIndexedKey)
            }
        }
    }
}

extension UIImage {
    func scaledImageWithWidth(_ width: CGFloat) -> UIImage {
        let imageScale = width / size.width
        let newSize = size.applying(CGAffineTransform(scaleX: imageScale, y: imageScale))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
