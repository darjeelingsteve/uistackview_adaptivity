//
//  CountyTests.swift
//  CountiesModelTests
//
//  Created by Stephen Anthony on 22/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesModel

final class CountyTests: XCTestCase {
    private var county: County!
    
    override func setUp() {
        super.setUp()
        let configurationURL = Bundle(for: CountryTests.self).url(forResource: "TestRegions", withExtension: "json")!
        county = try! JSONDecoder().decode(Country.self, from: Data(contentsOf: configurationURL)).regions[0].counties[0]
    }
    
    override func tearDown() {
        county = nil
        super.tearDown()
    }
    
    func testItFormatsThePopulationDetailsCorrectly() {
        XCTAssertEqual(county.populationDescription, "Population: 10 (2018)")
    }
}
