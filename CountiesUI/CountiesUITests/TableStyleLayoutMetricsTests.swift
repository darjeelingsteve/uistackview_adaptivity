//
//  TableStyleLayoutMetricsTests.swift
//  CountiesUITests
//
//  Created by Stephen Anthony on 23/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesUI

final class TableStyleLayoutMetricsTests: XCTestCase {
    private var metrics: TableStyleLayoutMetrics!
    
    override func tearDown() {
        metrics = nil
        super.tearDown()
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraSmallContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .extraSmall)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheSmallContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .small)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheMediumContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .medium)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .large)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 13, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 38)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 7)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .extraLarge)
        XCTAssertEqual(metrics.cellHeight, 48)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 15, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .extraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 17, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 50)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraExtraLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .extraExtraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 58)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 19, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 56)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 9)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityMediumContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .accessibilityMedium)
        XCTAssertEqual(metrics.cellHeight, 69)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 23, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 72)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .accessibilityLarge)
        XCTAssertEqual(metrics.cellHeight, 81)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 27, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 84)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .accessibilityExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 97)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 33, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 105)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 14)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .accessibilityExtraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 114)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 38, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 124)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 17)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraExtraLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 127)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 44, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 142)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheSameMetricsForTheUnsepcifiedContentSizeCategoryAsForTheLargeContentSizeCategory() {
        givenLayoutMetrics(forContentSizeCategory: .unspecified)
        let largeMetrics = TableStyleLayoutMetrics(contentSizeCategory: .large)
        XCTAssertEqual(metrics.cellHeight, largeMetrics.cellHeight)
        XCTAssertEqual(metrics.sectionHeaderFont, largeMetrics.sectionHeaderFont)
        XCTAssertEqual(metrics.sectionHeaderHeight, largeMetrics.sectionHeaderHeight)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, largeMetrics.sectionHeaderLabelBottomPadding)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: false))
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: true))
    }
    
    private func givenLayoutMetrics(forContentSizeCategory contentSizeCategory: UIContentSizeCategory) {
        metrics = TableStyleLayoutMetrics(contentSizeCategory: contentSizeCategory)
    }
}
