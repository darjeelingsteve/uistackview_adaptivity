//
//  CountyHistoryTests.swift
//  CountiesModelTests
//
//  Created by Stephen Anthony on 29/03/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesModel

final class CountyHistoryTests: XCTestCase {
    private static let testArchivedDataURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent("TestCountyHistory")
    
    private var countyHistory: CountyHistory!
    
    override func setUp() {
        super.setUp()
        countyHistory = CountyHistory(urlToArchivedData: CountyHistoryTests.testArchivedDataURL)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: CountyHistoryTests.testArchivedDataURL)
        countyHistory = nil
        super.tearDown()
    }
    
    @discardableResult private func whenTheUserViewsACounty(withName name: String) -> County {
        let county = Country.unitedKingdom.county(forName: name)!
        countyHistory.viewed(county)
        return county
    }
}

// MARK: - Viewing Counties
extension CountyHistoryTests {
    func testItRecordsWhenACountyHasBeenViewed() {
        let hampshire = whenTheUserViewsACounty(withName: "Hampshire")
        XCTAssertEqual(countyHistory.recentlyViewedCounties, [hampshire])
        
        let surrey = whenTheUserViewsACounty(withName: "Surrey")
        XCTAssertEqual(countyHistory.recentlyViewedCounties, [surrey, hampshire])
    }
    
    func testItDoesNotDuplicateCountiesWhenViewedMoreThanOnce() {
        let hampshire = whenTheUserViewsACounty(withName: "Hampshire")
        XCTAssertEqual(countyHistory.recentlyViewedCounties, [hampshire])
        
        whenTheUserViewsACounty(withName: "Hampshire")
        XCTAssertEqual(countyHistory.recentlyViewedCounties, [hampshire])
    }
    
    func testItLimitsTheHistoryToTheThreeMostRecentlyViewedCounties() {
        let hampshire = whenTheUserViewsACounty(withName: "Hampshire")
        let surrey = whenTheUserViewsACounty(withName: "Surrey")
        let cornwall = whenTheUserViewsACounty(withName: "Cornwall")
        XCTAssertEqual(countyHistory.recentlyViewedCounties, [cornwall, surrey, hampshire])
        
        let kent = whenTheUserViewsACounty(withName: "Kent")
        XCTAssertEqual(countyHistory.recentlyViewedCounties, [kent, cornwall, surrey])
    }
}

// MARK: - Notifications
extension CountyHistoryTests {
    func testItPostsANotificationWhenTheUserViewsACounty() {
        expectation(forNotification: CountyHistory.countyHistoryDidUpdateNotification, object: countyHistory, handler: nil)
        whenTheUserViewsACounty(withName: "Kent")
        waitForExpectations(timeout: 0, handler: nil)
    }
}
