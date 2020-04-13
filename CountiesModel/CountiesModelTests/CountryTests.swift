//
//  CountryTests.swift
//  CountiesModelTests
//
//  Created by Stephen Anthony on 07/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesModel

final class CountryTests: XCTestCase {
    private var country: Country!
    
    override func setUp() {
        super.setUp()
        let configurationURL = Bundle(for: CountryTests.self).url(forResource: "TestRegions", withExtension: "json")!
        country = try! JSONDecoder().decode(Country.self, from: Data(contentsOf: configurationURL))
    }
    
    override func tearDown() {
        country = nil
        super.tearDown()
    }
}

// MARK: - Deserialisation
extension CountryTests {
    func testItHasTheExpectedNumberOfRegions() {
        XCTAssertEqual(country.regions.count, 2)
    }
    
    func testItHasTheExpectedNumberOfCountiesInEachRegion() {
        XCTAssertEqual(country.regions.first?.counties.count, 1)
        XCTAssertEqual(country.regions.last?.counties.count, 2)
    }
    
    func testItHasTheExpectedCountyDataInTheFirstRegion() {
        XCTAssertEqual(country.regions.first?.name, "Region One")
        let county = country.regions.first?.counties.first
        XCTAssertEqual(county?.name, "Someshire")
        XCTAssertEqual(county?.population, County.Population(total: 10, year: 2018, source: URL(string: "https://darjeelingsteve.com/Someshire")!))
        XCTAssertEqual(county?.location.latitude, 51.6)
        XCTAssertEqual(county?.location.longitude, -1)
        XCTAssertEqual(county?.url, URL(string: "https://darjeelingsteve.com/Someshire")!)
    }
    
    func testItHasTheExpectedCountyDataInTheSecondRegion() {
        XCTAssertEqual(country.regions.last?.name, "Region Two")
        
        let countyOne = country.regions.last?.counties.first
        let countyTwo = country.regions.last?.counties.last
        
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
extension CountryTests {
    func testItLoadsTheUnitedKingdomRegionsAsExpected() {
        XCTAssertEqual(Country.unitedKingdom.regions.count, 12)
        
        XCTAssertEqual(Country.unitedKingdom.regions[0].counties.count, 8)
        XCTAssertEqual(Country.unitedKingdom.regions[1].counties.count, 5)
        XCTAssertEqual(Country.unitedKingdom.regions[2].counties.count, 1)
        XCTAssertEqual(Country.unitedKingdom.regions[3].counties.count, 5)
        XCTAssertEqual(Country.unitedKingdom.regions[4].counties.count, 7)
        XCTAssertEqual(Country.unitedKingdom.regions[5].counties.count, 5)
        XCTAssertEqual(Country.unitedKingdom.regions[6].counties.count, 1)
        XCTAssertEqual(Country.unitedKingdom.regions[7].counties.count, 2)
        XCTAssertEqual(Country.unitedKingdom.regions[8].counties.count, 4)
        XCTAssertEqual(Country.unitedKingdom.regions[9].counties.count, 7)
        XCTAssertEqual(Country.unitedKingdom.regions[10].counties.count, 8)
        XCTAssertEqual(Country.unitedKingdom.regions[11].counties.count, 6)
    }
}

// MARK: - County Lookup
extension CountryTests {
    func testItReturnsTheCountyForTheGivenName() {
        XCTAssertEqual(country.county(forName: "Anotherset")?.name, "Anotherset")
        XCTAssertEqual(country.county(forName: "Someothershire")?.name, "Someothershire")
    }
    
    func testItReturnsNilWhenNoCountyMatchesTheGivenName() {
        XCTAssertNil(country.county(forName: "Nowhere"))
    }
}

// MARK: - NSUserActivity
extension CountryTests {
    func testItReturnsTheCountyForTheUserActivity() {
        let userActivity = NSUserActivity(activityType: HandoffActivity.CountyDetails)
        userActivity.userInfo = [HandoffUserInfo.CountyName: "Someshire"]
        XCTAssertEqual(country.countyFrom(userActivity: userActivity)?.name, "Someshire")
    }
}

// MARK: - All Counties
extension CountryTests {
    func testItReturnsAllCountiesInAlphabeticalOrder() {
        XCTAssertEqual(country.allCounties.count, 3)
        XCTAssertEqual(country.allCounties[0].name, "Anotherset")
        XCTAssertEqual(country.allCounties[1].name, "Someothershire")
        XCTAssertEqual(country.allCounties[2].name, "Someshire")
    }
}

// MARK: - County Filtering
extension CountryTests {
    func testItFiltersRegionsCorrectlyByCountyWhenOnlyOneRegionMatches() {
        let counties = [country.county(forName: "Someothershire")!]
        let filteredRegions = country.regions.filtered(by: counties)
        XCTAssertEqual(filteredRegions.count, 1)
        XCTAssertEqual(filteredRegions.first?.name, "Region Two")
        XCTAssertEqual(filteredRegions.first?.counties.count, 1)
        XCTAssertEqual(filteredRegions.first?.counties, counties)
    }
    
    func testItFiltersRegionsCorrectlyByCountyWhenMultipleRegionsMatch() {
        let counties = [country.county(forName: "Anotherset")!, country.county(forName: "Someshire")!]
        let filteredRegions = country.regions.filtered(by: counties)
        XCTAssertEqual(filteredRegions.count, 2)
        XCTAssertEqual(filteredRegions.first?.name, "Region One")
        XCTAssertEqual(filteredRegions.first?.counties.count, 1)
        XCTAssertEqual(filteredRegions.first?.counties, [country.county(forName: "Someshire")!])
        XCTAssertEqual(filteredRegions.last?.name, "Region Two")
        XCTAssertEqual(filteredRegions.last?.counties.count, 1)
        XCTAssertEqual(filteredRegions.last?.counties, [country.county(forName: "Anotherset")!])
    }
    
    func testItFiltersRegionsCorrectlyByCountyWhenNoRegionsMatch() {
        let filteredRegions = country.regions.filtered(by: [])
        XCTAssertTrue(filteredRegions.isEmpty)
    }
    
    func testItReturnsRegionsWithSortedCounties() {
        let counties = [country.county(forName: "Someothershire")!, country.county(forName: "Anotherset")!]
        let filteredRegions = country.regions.filtered(by: counties)
        XCTAssertEqual(filteredRegions.count, 1)
        XCTAssertEqual(filteredRegions.first?.name, "Region Two")
        XCTAssertEqual(filteredRegions.first?.counties.count, 2)
        XCTAssertEqual(filteredRegions.first?.counties, [country.county(forName: "Anotherset")!, country.county(forName: "Someothershire")!])
    }
}
