//
//  Country+NSUserActivity.swift
//  CountiesModel
//
//  Created by Stephen Anthony on 08/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import Foundation

extension Country {
    public func countyFrom(userActivity: NSUserActivity?) -> County? {
        guard let userInfo = userActivity?.userInfo, let countyName = userInfo[HandoffUserInfo.CountyName] as? String else {
            return nil
        }
        return county(forName: countyName)
    }
}
