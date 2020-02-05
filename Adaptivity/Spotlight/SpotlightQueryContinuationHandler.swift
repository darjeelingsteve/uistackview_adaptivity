//
//  SpotlightQueryContinuationHandler.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 07/11/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation
import CoreSpotlight
import CountiesModel

class SpotlightQueryContinuationHandler: UserActivityHandling {
    var handledActivityType: String {
        return CSQueryContinuationActionType
    }
    
    func resultFromUserActivity(_ userActivity: NSUserActivity) -> UserActivityHandlingResult? {
        guard let searchText = userActivity.userInfo?[CSSearchQueryString] as? String else {
            return nil
        }
        return .searchText(searchText: searchText)
    }
}
