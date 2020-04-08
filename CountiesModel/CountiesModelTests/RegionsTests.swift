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
}

// MARK: - Deserialisation
extension RegionsTests {
    func testItHasTheExpectedNumberOfRegions() {
        XCTAssertEqual(regions.regions.count, 2)
    }
    
    func testItHasTheExpectedNumberOfCountiesInEachRegion() {
        XCTAssertEqual(regions.regions.first?.counties.count, 1)
        XCTAssertEqual(regions.regions.last?.counties.count, 2)
    }
    
    func testItHasTheExpectedCountyDataInTheFirstRegion() {
        XCTAssertEqual(regions.regions.first?.name, "Region One")
        let county = regions.regions.first?.counties.first
        XCTAssertEqual(county?.name, "Someshire")
        XCTAssertEqual(county?.population, County.Population(total: 10, year: 2018, source: URL(string: "https://darjeelingsteve.com/Someshire")!))
        XCTAssertEqual(county?.location.latitude, 51.6)
        XCTAssertEqual(county?.location.longitude, -1)
        XCTAssertEqual(county?.url, URL(string: "https://darjeelingsteve.com/Someshire")!)
    }
    
    func testItHasTheExpectedCountyDataInTheSecondRegion() {
        XCTAssertEqual(regions.regions.last?.name, "Region Two")
        
        let countyOne = regions.regions.last?.counties.first
        let countyTwo = regions.regions.last?.counties.last
        
        XCTAssertEqual(countyOne?.name, "Someothershire")
        XCTAssertEqual(countyOne?.population, County.Population(total: 20, year: 2019, source: URL(string: "https://darjeelingsteve.com/Someothershire")!))
        XCTAssertEqual(countyOne?.location.latitude, 50.3)
        XCTAssertEqual(countyOne?.location.longitude, -4.9)
        XCTAssertEqual(countyOne?.url, URL(string: "https://darjeelingsteve.com/Someothershire")!)
        
        XCTAssertEqual(countyTwo?.name, "Anotherset")
        XCTAssertEqual(countyTwo?.population, County.Population(total: 30, year: 2020, source: URL(string: "https://darjeelingsteve.com/Anotherset")!))
        XCTAssertEqual(countyTwo?.location.latitude, 50.7)
        XCTAssertEqual(countyTwo?.location.longitude, -3.8)
        XCTAssertEqual(countyTwo?.url, URL(string: "https://darjeelingsteve.com/Anotherset")!)
    }
}

// MARK: - United Kingdom
extension RegionsTests {
    func testItLoadsTheUnitedKingdomRegionsAsExpected() {
        XCTAssertEqual(Regions.unitedKingdom.regions.count, 12)
        
        XCTAssertEqual(Regions.unitedKingdom.regions[0].counties.count, 8)
        XCTAssertEqual(Regions.unitedKingdom.regions[1].counties.count, 5)
        XCTAssertEqual(Regions.unitedKingdom.regions[2].counties.count, 1)
        XCTAssertEqual(Regions.unitedKingdom.regions[3].counties.count, 5)
        XCTAssertEqual(Regions.unitedKingdom.regions[4].counties.count, 7)
        XCTAssertEqual(Regions.unitedKingdom.regions[5].counties.count, 5)
        XCTAssertEqual(Regions.unitedKingdom.regions[6].counties.count, 1)
        XCTAssertEqual(Regions.unitedKingdom.regions[7].counties.count, 2)
        XCTAssertEqual(Regions.unitedKingdom.regions[8].counties.count, 4)
        XCTAssertEqual(Regions.unitedKingdom.regions[9].counties.count, 7)
        XCTAssertEqual(Regions.unitedKingdom.regions[10].counties.count, 8)
        XCTAssertEqual(Regions.unitedKingdom.regions[11].counties.count, 6)
    }
}
