//
//  FavouritesControllerTests.swift
//  CountiesTests
//
//  Created by Stephen Anthony on 20/01/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import Counties

final class FavouritesControllerTests: XCTestCase {
    private var favouritesController: FavouritesController!
    private var mockUbiquitousKeyValueStorageProvider: MockUbiquitousKeyValueStorageProvider!
    private let defaultFavouriteCounties: [County] = [County.countyForName("Hampshire")!, County.countyForName("Devon")!]
    
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
        let surrey = County.countyForName("Surrey")!
        favouritesController.add(county: surrey)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedObject as? [County], [surrey])
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    func testItCanAddACountyToAnExistingListOfFavourites() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet()
        let kent = County.countyForName("Kent")!
        favouritesController.add(county: kent)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedObject as? [County], defaultFavouriteCounties + [kent])
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    func testItCanRemoveACountyFromTheFavouritesList() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet()
        let Hampshire = County.countyForName("Hampshire")!
        favouritesController.remove(county: Hampshire)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedObject as? [County], [County.countyForName("Devon")!])
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    func testItDoesNotAllowAddingTheSameCountyTwice() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet() // Includes Hampshire
        let hampshire = County.countyForName("Hampshire")!
        favouritesController.add(county: hampshire)
        XCTAssertNil(mockUbiquitousKeyValueStorageProvider.receivedObject)
    }
    
    func testItIgnoresCallsToRemoveCountiesThatAreNotFavourites() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet() // Does not include Essex
        let essex = County.countyForName("Essex")!
        favouritesController.remove(county: essex)
        XCTAssertNil(mockUbiquitousKeyValueStorageProvider.receivedObject)
    }
    
    func testItReportsTheUsersFavouriteCountiesCorrectly() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet()
        XCTAssertEqual(favouritesController.favouriteCounties, defaultFavouriteCounties)
        XCTAssertEqual(mockUbiquitousKeyValueStorageProvider.receivedKey, "FavouriteCounties")
    }
    
    private func givenADefaultSetOfFavouriteCountiesHaveBeenSet() {
        mockUbiquitousKeyValueStorageProvider.mockArrayForKey = defaultFavouriteCounties
    }
}

// MARK: - Notifications
extension FavouritesControllerTests {
    func testItPostsANotifcationWhenTheUserAddsAFavourite() {
        expectation(forNotification: FavouritesController.favouriteCountiesDidChangeNotification, object: favouritesController, handler: nil)
        let kent = County.countyForName("Kent")!
        favouritesController.add(county: kent)
        waitForExpectations(timeout: 0, handler: nil)
    }
    
    func testItPostsANotifcationWhenTheUserRemovesAFavourite() {
        givenADefaultSetOfFavouriteCountiesHaveBeenSet() // Includes Hampshire
        expectation(forNotification: FavouritesController.favouriteCountiesDidChangeNotification, object: favouritesController, handler: nil)
        let hampshire = County.countyForName("Hampshire")!
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
