//
//  CountyUserActivityHandling.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation

/**
 The protocol to conform to for classes that handle user activities.
 */
protocol CountyUserActivityHandling: class {
    /// The activity type handled by the activity handler.
    var handledActivityType: String {get}
    
    /**
     Called when the receiver is to handle a user activity. Will only be called
     with user activities whose `activityType` matches the type returned by
     the reveiver's `handledActivityType` property.
     - parameter userActivity: The user activity to handle.
     - returns: The county contained in the user activity if one was found, nil
     otherwise.
     */
    func countyFromUserActivity(userActivity: NSUserActivity) -> County?
}

extension CountyUserActivityHandling {
    /**
     Called when the receiver is to handle a user activity involving a county.
     - parameter userActivity:      The user activity to handle.
     - parameter completionHandler: Supplies the county specified by the user
     activity if it could be handled.
     - returns: A boolean indicating whether the user activity was handled or
     not.
     */
    func handleUserActivity(userActivity: NSUserActivity, @noescape completionHandler: (County) -> Void) -> Bool {
        if userActivity.activityType == handledActivityType {
            if let selectedCounty = countyFromUserActivity(userActivity) {
                completionHandler(selectedCounty)
                return true
            }
        }
        
        return false
    }
}