//
//  CountyHistory.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 29/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation
import CountiesModel

/// The object responsible for recording which counties the user has viewed.
class CountyHistory: NSObject {
    static let shared = CountyHistory()
    
    var delegate: CountyHistoryDelegate?
    
    private(set) var recentlyViewedCounties: [County] {
        get {
            let countyNames = NSArray(contentsOf: urlToArchivedData) as? [String]
            if let countyNames = countyNames {
                return countyNames.map({ (countyName) -> County in
                    County.countyForName(countyName)!
                })
            }
            else {
                return []
            }
        }
        set {
            let countyNames = newValue.map({$0.name}) as NSArray
            countyNames.write(to: urlToArchivedData, atomically: true)
        }
    }
    
    private var urlToArchivedData: URL {
        let documentsURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        return documentsURL.appendingPathComponent("CountyHistory")
    }
    
    /**
     Call this function when the user views a county.
     - parameter county: The county viewed by the user.
     */
    func viewed(_ county: County) {
        if let countyIndex = recentlyViewedCounties.firstIndex(of: county) {
            recentlyViewedCounties.remove(at: countyIndex)
        }
        recentlyViewedCounties.insert(county, at: 0)
        recentlyViewedCounties = Array(recentlyViewedCounties.prefix(3))
        delegate?.countyHistoryDidUpdate(self)
    }
}

/**
 The protocol for `CountyHistory` delegates to conform to.
 */
protocol CountyHistoryDelegate: NSObjectProtocol {
    /**
     The message sent when the county history was updated.
     - parameter countyHistory: The county history that was updated.
     */
    func countyHistoryDidUpdate(_ countyHistory: CountyHistory)
}
