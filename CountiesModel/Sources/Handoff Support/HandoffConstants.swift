//
//  HandoffConstants.swift
//  CountiesModel
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation

/**
 The different activity types that are available for handoff
 */
public struct HandoffActivity {
    public static let CountyDetails = "com.darjeeling.counties.handoff.countydetails"
}

/**
 The userInfo keys used when transferring details via handoff
 */
struct HandoffUserInfo {
    static let CountyName = "CountyName"
}
