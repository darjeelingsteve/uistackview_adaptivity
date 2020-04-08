//
//  SpotlightController+UserActivityHandling.swift
//  Counties
//
//  Created by Stephen Anthony on 05/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import Foundation
import CoreSpotlight
import CountiesModel

// MARK: UserActivityHandling
extension SpotlightController: UserActivityHandling {
    var handledActivityType: String {
        return CSSearchableItemActionType
    }
    
    func resultFromUserActivity(_ userActivity: NSUserActivity) -> UserActivityHandlingResult? {
        guard let countyName = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String, let county = Country.unitedKingdom.county(forName: countyName) else {
            return nil
        }
        return .county(county: county)
    }
}
