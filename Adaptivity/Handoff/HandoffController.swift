//
//  HandoffController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation

/// The class rsponsible for handling user activities provided during Handoff.
class HandoffController: UserActivityHandling {
    // MARK: CountyUserActivityHandling
    var handledActivityType: String {
        get {
            return HandoffActivity.CountyDetails
        }
    }
    
    func resultFromUserActivity(_ userActivity: NSUserActivity) -> UserActivityHandlingResult? {
        guard let userInfo = userActivity.userInfo, let countyName = userInfo[HandoffUserInfo.CountyName] as? String, let selectedCounty = County.countyForName(countyName) else {
            return nil
        }
        return .county(county: selectedCounty)
    }
}
