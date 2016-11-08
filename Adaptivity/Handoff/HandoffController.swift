//
//  HandoffController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import WatchKit

class HandoffController: UserActivityHandling {
    // MARK: CountyUserActivityHandling
    var handledActivityType: String {
        get {
            return HandoffActivity.CountyDetails
        }
    }
    
    func countyFromUserActivity(_ userActivity: NSUserActivity) -> County? {
        if let userInfo = userActivity.userInfo, let countyName = userInfo[HandoffUserInfo.CountyName] as? String, let selectedCounty = County.countyForName(countyName) {
            return selectedCounty
        }
        return nil
    }
}
