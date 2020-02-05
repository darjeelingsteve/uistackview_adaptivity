//
//  FavouritesControllerTests.swift
//  CountiesModelTests
//
//  Created by Stephen Anthony on 20/01/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesModel

final class FavouritesControllerTests: XCTestCase {
    private var favouritesController: FavouritesController!
    private var mockUbiquitousKeyValueStorageProvider: MockUbiquitousKeyValueStorageProvider!
    private let defaultFavouriteCountyNames = ["Devon", "Hampshire"]
    
    override func setUp() {
        super.setUp()
        mockUbiquitousKeyValueStorageProvider = MockUbiquitousKeyValueStorageProvider()
        favouritesController = FavouritesController(ubiquitousKeyValueStore: mockUbiquitousKeyValueStorageProvider)
    }
    
    override func tearDown() {
        mockUbiquitousKeyValueStorageProvider = nil
        favouritesController = nil
        super.tearDown()
    }
    
    func testItCanSetACountyAsAFavourite() {
        let surrey = County.forName("Surrey")!
        favouritesController.add(county: surrey)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedObject as? [String], [surrey.name])
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    func testItCanAddACountyToAnExistingListOfFavourites() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet()
        let kent = County.forName("Kent")!
        favouritesController.add(county: kent)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedObject as? [String], defaultFavouriteCountyNames + [kent.name])
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    func testItCanRemoveACountyFromTheFavouritesList() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet()
        let Hampshire = County.forName("Hampshire")!
        favouritesController.remove(county: Hampshire)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedObject as? [String], ["Devon"])
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    func testItDoesNotAllowAddingTheSameCountyTwice() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet() // Includes Hampshire
        let hampshire = County.forName("Hampshire")!
        favouritesController.add(county: hampshire)
        XCTAssertNil(mockUbiquitousKeyValueStorageProvider.receivedObject)
    }
    
    func testItIgnoresCallsToRemoveCountiesThatAreNotFavourites() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet() // Does not include Essex
        let essex = County.forName("Essex")!
        favouritesController.remove(county: essex)
        XCTAssertNil(mockUbiquitousKeyValueStorageProvider.receivedObject)
    }
    
    func testItStoresCountiesInAlphabeticalOrder() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet() // Does not include Essex
        let essex = County.forName("Essex")!
        favouritesController.add(county: essex)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedObject as? [String], [defaultFavouriteCountyNames[0], essex.name, defaultFavouriteCountyNames[1]])
    }
    
    func testItReportsTheUsersFavouriteCountiesCorrectly() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet()
        XCTAssertEqual(favouritesController.favouriteCounties, defaultFavouriteCountyNames.compactMap { County.forName($0) })
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    private func givenADefaultSetOfFavouriteCountiesHaveBeenSet() {
        mockUbiquitousKeyValueStorageProvider.mockArrayForKey = defaultFavouriteCountyNames
    }
}

// MARK: - Notifications
extension FavouritesControllerTests {
    func testItPostsANotifcationWhenTheUserAddsAFavourite() {
        expectation(forNotification: FavouritesController.favouriteCountiesDidChangeNotification, object: favouritesController, handler: nil)
        let kent = County.forName("Kent")!
        favouritesController.add(county: kent)
        waitForExpectations(timeout: 0, handler: nil)
    }
    
    func testItPostsANotifcationWhenTheUserRemovesAFavourite() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet() // Includes Hampshire
        expectation(forNotification: FavouritesController.favouriteCountiesDidChangeNotification, object: favouritesController, handler: nil)
        let hampshire = County.forName("Hampshire")!
        favouritesController.remove(county: hampshire)
        waitForExpectations(timeout: 0, handler: nil)
    }
}

// MARK: - Synchronisation
extension FavouritesControllerTests {
    func testItSynchronisesItsUbiquitousKeyValueStorageWhenRequested() {
        favouritesController.synchronise()
        XCTAssertTrue(mockUbiquitousKeyValueStorageProvider.receivedSynchronizeMessage)
    }
}

private class MockUbiquitousKeyValueStorageProvider: UbiquitousKeyValueStorageProviding {
    private(set) var receivedObject: Any?
    private(set) var receivedKey: String?
    var mockArrayForKey: [Any]?
    private(set) var receivedSynchronizeMessage = false
    
    func set(_ anObject: Any?, forKey aKey: String) {
        receivedObject = anObject
        receivedKey = aKey
    }
    
    func array(forKey aKey: String) -> [Any]? {
        receivedKey = aKey
        return mockArrayForKey
    }
    
    func synchronize() -> Bool {
        receivedSynchronizeMessage = true
        return false
    }
}

