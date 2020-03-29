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
}

// MARK: - Notifications
extension CountyHistoryTests {
    func testItPostsANotificationWhenTheUserViewsACounty() {
        expectation(forNotification: CountyHistory.countyHistoryDidUpdateNotification, object: countyHistory, handler: nil)
        let kent = County.forName("Kent")!
        countyHistory.viewed(kent)
        waitForExpectations(timeout: 0, handler: nil)
    }
}
