//
//  UserActivityHandling.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation

/// The result type given by `UserActivityHandling` instances when a user activity can be handled.
///
/// - county: The county that was found to match the user activity.
/// - searchText: The search text that was found inside the user activity.
enum UserActivityHandlingResult {
    case county(county: County)
    case searchText(searchText: String)
}

/**
 The protocol to conform to for classes that handle user activities.
 */
protocol UserActivityHandling: class {
    /// The activity type handled by the activity handler.
    var handledActivityType: String {get}
    
    /// Called when the receiver is to handle a user activity. Must return `nil` if the user activity cannot be handled.
    ///
    /// - Parameter userActivity: The user activity to handle.
    /// - Returns: The result contained in the user activity if one was found, nil otherwise.
    func resultFromUserActivity(_ userActivity: NSUserActivity) -> UserActivityHandlingResult?
}

extension UserActivityHandling {
    /**
     Called when the receiver is to handle a user activity.
     - parameter userActivity:      The user activity to handle.
     - parameter completionHandler: Supplies the result specified by the user activity if it could be handled.
     - returns: A boolean indicating whether the user activity was handled or not.
     */
    func handleUserActivity(_ userActivity: NSUserActivity, completionHandler: (UserActivityHandlingResult) -> Void) -> Bool {
        guard userActivity.activityType == handledActivityType, let result = resultFromUserActivity(userActivity) else {
            return false
        }
        completionHandler(result)
        return true
    }
}

// MARK: - CustomReflectable
extension NSUserActivity : CustomReflectable {
    public var customMirror: Mirror {
        let children = DictionaryLiteral<String, Any>(dictionaryLiteral:
            ("activityType", activityType),
                                                      ("title", title ?? "None"),
                                                      ("userInfo", userInfo.debugDescription),
                                                      ("requiredUserInfoKeys", requiredUserInfoKeys),
                                                      ("needsSave", needsSave),
                                                      ("webpageURL", webpageURL ?? "None"),
                                                      ("expirationDate", expirationDate.debugDescription),
                                                      ("keywords", keywords),
                                                      ("supportsContinuationStreams", supportsContinuationStreams))
        return Mirror(NSUserActivity.self, children: children, displayStyle: .class, ancestorRepresentation: .suppressed)
    }
}