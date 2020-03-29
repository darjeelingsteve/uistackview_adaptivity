//
//  CountyHistory.swift
//  CountiesModel iOS
//
//  Created by Stephen Anthony on 29/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation

/// The object responsible for recording which counties the user has viewed.
public class CountyHistory: NSObject {
    
    /// The notification posted when the user's county viewing history is
    /// updated.
    public static let countyHistoryDidUpdateNotification = NSNotification.Name("CountyHistoryDidUpdate")
    
    private static let defaultArchivedDataURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent("CountyHistory")
    
    /// The shared instance of `CountyHistory`.
    public static let shared = CountyHistory()
    
    public var delegate: CountyHistoryDelegate?
    
    private(set) public var recentlyViewedCounties: [County] {
        get {
            let countyNames = NSArray(contentsOf: urlToArchivedData) as? [String]
            if let countyNames = countyNames {
                return countyNames.map({ (countyName) -> County in
                    County.forName(countyName)!
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
    
    private let urlToArchivedData: URL
    
    /// Prevent initialisation from outside of `CountiesModel`.
    init(urlToArchivedData: URL = CountyHistory.defaultArchivedDataURL) {
        self.urlToArchivedData = urlToArchivedData
    }
    
    /**
     Call this function when the user views a county.
     - parameter county: The county viewed by the user.
     */
    public func viewed(_ county: County) {
        if let countyIndex = recentlyViewedCounties.firstIndex(of: county) {
            recentlyViewedCounties.remove(at: countyIndex)
        }
        recentlyViewedCounties.insert(county, at: 0)
        recentlyViewedCounties = Array(recentlyViewedCounties.prefix(3))
        NotificationCenter.default.post(name: CountyHistory.countyHistoryDidUpdateNotification, object: self)
        delegate?.countyHistoryDidUpdate(self)
    }
}

/**
 The protocol for `CountyHistory` delegates to conform to.
 */
public protocol CountyHistoryDelegate: NSObjectProtocol {
    /**
     The message sent when the county history was updated.
     - parameter countyHistory: The county history that was updated.
     */
    func countyHistoryDidUpdate(_ countyHistory: CountyHistory)
}
