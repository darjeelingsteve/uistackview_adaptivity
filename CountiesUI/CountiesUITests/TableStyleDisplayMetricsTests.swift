//
//  TableStyleDisplayMetricsTests.swift
//  CountiesUITests
//
//  Created by Stephen Anthony on 23/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesUI

final class TableStyleDisplayMetricsTests: XCTestCase {
    private var metrics: TableStyleDisplayMetrics!
    
    override func tearDown() {
        metrics = nil
        super.tearDown()
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraSmallContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraSmall)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheSmallContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .small)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheMediumContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .medium)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .large)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 13, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 38)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 7)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraLarge)
        XCTAssertEqual(metrics.cellHeight, 48)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 15, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 17, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 50)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraExtraLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraExtraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 58)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 19, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 56)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 9)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityMediumContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityMedium)
        XCTAssertEqual(metrics.cellHeight, 69)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 23, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 72)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityLarge)
        XCTAssertEqual(metrics.cellHeight, 81)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 27, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 84)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 97)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 33, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 105)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 14)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 114)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 38, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 124)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 17)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraExtraLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        XCTAssertEqual(metrics.cellHeight, 127)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 44, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 142)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 18)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheSameMetricsForTheUnsepcifiedContentSizeCategoryAsForTheLargeContentSizeCategory() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .unspecified)
        let largeMetrics = TableStyleDisplayMetrics(traitCollection: UITraitCollection(preferredContentSizeCategory: .large))
        XCTAssertEqual(metrics.cellHeight, largeMetrics.cellHeight)
        XCTAssertEqual(metrics.sectionHeaderFont, largeMetrics.sectionHeaderFont)
        XCTAssertEqual(metrics.sectionHeaderHeight, largeMetrics.sectionHeaderHeight)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, largeMetrics.sectionHeaderLabelBottomPadding)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), largeMetrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5))
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: false))
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: true))
    }
    
    func testItReturnsTheCorrectHeaderTextColourInLightInterfaceStyle() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .large)
        performTest(withUserInterfaceStyle: .light) {
            XCTAssertEqual(metrics.sectionHeaderTextColour.cgColor, UIColor(red: 0.43, green: 0.43, blue: 0.45, alpha: 1).cgColor)
        }
    }
    
    func testItReturnsTheCorrectHeaderTextColourInDarkInterfaceStyle() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .large)
        performTest(withUserInterfaceStyle: .dark) {
            XCTAssertEqual(metrics.sectionHeaderTextColour.cgColor, UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1).cgColor)
        }
    }
    
    private func givenDisplayMetrics(forPreferredContentSizeCategory preferredContentSizeCategory: UIContentSizeCategory) {
        let traitCollection = UITraitCollection(preferredContentSizeCategory: preferredContentSizeCategory)
        metrics = TableStyleDisplayMetrics(traitCollection: traitCollection)
    }
    
    private func performTest(withUserInterfaceStyle userInterfaceStyle: UIUserInterfaceStyle, tests: () -> Void) {
        let traitCollection = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        traitCollection.performAsCurrent(tests)
    }
}
