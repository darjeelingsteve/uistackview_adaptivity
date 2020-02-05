//
//  FavouritesController.swift
//  Counties
//
//  Created by Stephen Anthony on 20/01/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import Foundation
import CountiesModel

/// The object responsible for managing the list of the user's favourite
/// counties.
final class FavouritesController {
    
    /// The shared instance of `FavouritesController`. Should be used over
    /// individual instances.
    static let shared = FavouritesController()
    
    /// The notification posted when the user adds or removes a favourite
    /// county.
    static let favouriteCountiesDidChangeNotification = NSNotification.Name("FavouriteCountiesDidChange")
    
    private static let favouriteCountiesKey = "FavouriteCounties"
    
    /// The counties that the user has chosen as their favourites.
    var favouriteCounties: [County] {
        let counties = (ubiquitousKeyValueStore.array(forKey: FavouritesController.favouriteCountiesKey) as? [String])?.compactMap({ County.countyForName($0) })
        return counties ?? []
    }
    
    private let ubiquitousKeyValueStore: UbiquitousKeyValueStorageProviding
    
    /// Initialises a new `FavouritesController` backed by the given ubiquitous
    /// key-value store.
    /// - Parameter ubiquitousKeyValueStore: The ubiquitous key-value store used
    /// to persist the user's favourite counties.
    init(ubiquitousKeyValueStore: UbiquitousKeyValueStorageProviding = NSUbiquitousKeyValueStore.default) {
        self.ubiquitousKeyValueStore = ubiquitousKeyValueStore
    }
    
    /// Adds the given county to the user's favourites.
    /// - Parameter county: The county to add to the user's favourites.
    func add(county: County) {
        guard favouriteCounties.firstIndex(of: county) == nil else { return }
        ubiquitousKeyValueStore.set((favouriteCounties + [county]).sorted().countyNames, forKey: FavouritesController.favouriteCountiesKey)
        NotificationCenter.default.post(name: FavouritesController.favouriteCountiesDidChangeNotification, object: self)
    }
    
    /// Removes the given county from the user's favourites.
    /// - Parameter county: The county to remove from the user's favourites.
    func remove(county: County) {
        guard let countyIndex = favouriteCounties.firstIndex(of: county) else { return }
        var mutableFavourites = favouriteCounties
        mutableFavourites.remove(at: countyIndex)
        ubiquitousKeyValueStore.set(mutableFavourites.countyNames, forKey: FavouritesController.favouriteCountiesKey)
        NotificationCenter.default.post(name: FavouritesController.favouriteCountiesDidChangeNotification, object: self)
    }
    
    /// Synchronises the receiver's ubiquitous key-value store.
    func synchronise() {
        _ = ubiquitousKeyValueStore.synchronize()
    }
}

protocol UbiquitousKeyValueStorageProviding {
    func set(_ anObject: Any?, forKey aKey: String)
    func array(forKey aKey: String) -> [Any]?
    func synchronize() -> Bool
}

extension NSUbiquitousKeyValueStore: UbiquitousKeyValueStorageProviding {}

private extension Array where Element == County {
    var countyNames: [String] {
        return map { $0.name }
    }
}
