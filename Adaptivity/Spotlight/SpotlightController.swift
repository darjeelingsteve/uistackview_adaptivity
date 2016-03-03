//
//  SpotlightController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 25/01/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

private let SpotlightControllerHasIndexedKey = "HasIndexed"

/// The class responsible for managing the Spotlight index for County objects
class SpotlightController: NSObject, CountyUserActivityHandling {
    func indexCounties(counties: [County]) {
        if CSSearchableIndex.isIndexingAvailable() == false || NSUserDefaults.standardUserDefaults().boolForKey(SpotlightControllerHasIndexedKey) == true {
            // We either can't index or don't need to
            return
        }
        
        let searchableItems = counties.map { (county) -> CSSearchableItem in
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
            attributeSet.title = county.name
            attributeSet.contentDescription = county.populationDescription
            attributeSet.latitude = county.latitude
            attributeSet.longitude = county.longitude
            attributeSet.supportsNavigation = 1
            if let countyFlag = county.flagImage {
                // Scale image as recommended by https://developer.apple.com/library/ios/documentation/General/Conceptual/AppSearch/SearchUserExperience.html#//apple_ref/doc/uid/TP40016308-CH11-SW1
                attributeSet.thumbnailData = UIImagePNGRepresentation(countyFlag.scaledImageWithWidth(270))
            }
            let searchableItem = CSSearchableItem(uniqueIdentifier: county.name, domainIdentifier: nil, attributeSet: attributeSet)
            return searchableItem
        }
        
        let searchableIndex = CSSearchableIndex.defaultSearchableIndex()
        searchableIndex.indexSearchableItems(searchableItems) { (error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: SpotlightControllerHasIndexedKey)
            }
        }
    }
    
    //MARK: CountyUserActivityHandling
    var handledActivityType: String {
        get {
            return CSSearchableItemActionType
        }
    }
    
    func countyFromUserActivity(userActivity: NSUserActivity) -> County? {
        return County.countyForName(userActivity.title ?? "")
    }
}

extension UIImage {
    func scaledImageWithWidth(width: CGFloat) -> UIImage {
        let imageScale = width / self.size.width
        let size = CGSizeApplyAffineTransform(self.size, CGAffineTransformMakeScale(imageScale, imageScale))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        self.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}
