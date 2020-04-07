//
//  RegionsTests.swift
//  CountiesModelTests
//
//  Created by Stephen Anthony on 07/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesModel

final class RegionsTests: XCTestCase {
    private var regions: Regions!
    
    override func setUp() {
        super.setUp()
        let configurationURL = Bundle(for: RegionsTests.self).url(forResource: "TestRegions", withExtension: "json")!
        regions = Regions(configurationURL: configurationURL)
    }
    
    override func tearDown() {
        regions = nil
        super.tearDown()
    }
    
    func testItHasTheExpectedNumberOfRegions() {
        XCTAssertEqual(regions.regions.count, 2)
    }
    
    func testItHasTheExpectedNumberOfCountiesInEachRegion() {
        XCTAssertEqual(regions.regions.first?.counties.count, 1)
        XCTAssertEqual(regions.regions.last?.counties.count, 2)
    }
    
    func testItHasTheExpectedCountyDataInTheFirstRegion() {
        let county = regions.regions.first?.counties.first
        XCTAssertEqual(county?.name, "Someshire")
        XCTAssertEqual(county?.population, County.Population(total: 10, year: 2018, source: URL(string: "https://darjeelingsteve.com/Someshire")!))
        XCTAssertEqual(county?.latitude, 51.6)
        XCTAssertEqual(county?.longitude, -1)
        XCTAssertEqual(county?.url, URL(string: "https://darjeelingsteve.com/Someshire")!)
    }
    
    func testItHasTheExpectedCountyDataInTheSecondRegion() {
        let countyOne = regions.regions.last?.counties.first
        let countyTwo = regions.regions.last?.counties.last
        
        XCTAssertEqual(countyOne?.name, "Someothershire")
        XCTAssertEqual(countyOne?.population, County.Population(total: 20, year: 2019, source: URL(string: "https://darjeelingsteve.com/Someothershire")!))
        XCTAssertEqual(countyOne?.latitude, 50.3)
        XCTAssertEqual(countyOne?.longitude, -4.9)
        XCTAssertEqual(countyOne?.url, URL(string: "https://darjeelingsteve.com/Someothershire")!)
        
        XCTAssertEqual(countyTwo?.name, "Anotherset")
        XCTAssertEqual(countyTwo?.population, County.Population(total: 30, year: 2020, source: URL(string: "https://darjeelingsteve.com/Anotherset")!))
        XCTAssertEqual(countyTwo?.latitude, 50.7)
        XCTAssertEqual(countyTwo?.longitude, -3.8)
        XCTAssertEqual(countyTwo?.url, URL(string: "https://darjeelingsteve.com/Anotherset")!)
    }
}
