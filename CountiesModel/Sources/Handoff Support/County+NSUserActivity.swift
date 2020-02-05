//
//  County+NSUserActivity.swift
//  CountiesModel
//
//  Created by Stephen Anthony on 19/12/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import Foundation

extension County {
    public var userActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: HandoffActivity.CountyDetails)
        userActivity.userInfo = [HandoffUserInfo.CountyName: name]
        return userActivity
    }
    
    public static func from(userActivity: NSUserActivity?) -> County? {
        guard let userInfo = userActivity?.userInfo, let countyName = userInfo[HandoffUserInfo.CountyName] as? String else {
            return nil
        }
        return County.countyForName(countyName)
    }
}
