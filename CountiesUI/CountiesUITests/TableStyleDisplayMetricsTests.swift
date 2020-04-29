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
    
    private func givenDisplayMetrics(forPreferredContentSizeCategory preferredContentSizeCategory: UIContentSizeCategory, userInterfaceIdiom: UIUserInterfaceIdiom) {
        metrics = displayMetrics(forPreferredContentSizeCategory: preferredContentSizeCategory, userInterfaceIdiom: userInterfaceIdiom)
    }
    
    private func displayMetrics(forPreferredContentSizeCategory preferredContentSizeCategory: UIContentSizeCategory, userInterfaceIdiom: UIUserInterfaceIdiom) -> TableStyleDisplayMetrics {
        let contentSizeCategoryTraitCollection = UITraitCollection(preferredContentSizeCategory: preferredContentSizeCategory)
        let userInterfaceIdiomTraitCollection = UITraitCollection(userInterfaceIdiom: userInterfaceIdiom)
        return TableStyleDisplayMetrics(traitCollection: UITraitCollection(traitsFrom: [contentSizeCategoryTraitCollection, userInterfaceIdiomTraitCollection]))
    }
    
    private func performTest(withUserInterfaceStyle userInterfaceStyle: UIUserInterfaceStyle, tests: () -> Void) {
        let traitCollection = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        traitCollection.performAsCurrent(tests)
    }
}

// MARK: - iPhone User Interface Idiom
extension TableStyleDisplayMetricsTests {
    func testItReturnsTheExpectedMetricsForTheExtraSmallContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraSmall, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheSmallContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .small, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheMediumContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .medium, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .large, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 13, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 38)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 7)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraLarge, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 48)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 15, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraExtraLarge, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 17, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 50)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraExtraLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraExtraExtraLarge, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 58)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 19, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 56)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 9)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityMediumContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityMedium, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 69)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 23, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 72)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityLarge, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 81)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 27, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 84)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraLarge, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 97)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 33, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 105)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 14)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraExtraLarge, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 114)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 38, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 124)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 17)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraExtraLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraExtraExtraLarge, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, 127)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 44, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 142)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 18)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheSameMetricsForTheUnsepcifiedContentSizeCategoryAsForTheLargeContentSizeCategoryOniPhone() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .unspecified, userInterfaceIdiom: .phone)
        let largeMetrics = displayMetrics(forPreferredContentSizeCategory: .large, userInterfaceIdiom: .phone)
        XCTAssertEqual(metrics.cellHeight, largeMetrics.cellHeight)
        XCTAssertEqual(metrics.sectionHeaderFont, largeMetrics.sectionHeaderFont)
        XCTAssertEqual(metrics.sectionHeaderHeight, largeMetrics.sectionHeaderHeight)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, largeMetrics.sectionHeaderLabelBottomPadding)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), largeMetrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5))
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: false))
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: true))
    }
}

// MARK: - iPad User Interface Idiom
extension TableStyleDisplayMetricsTests {
    func testItReturnsTheExpectedMetricsForTheExtraSmallContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraSmall, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheSmallContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .small, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheMediumContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .medium, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 12, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 32)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 6)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .large, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 13, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 38)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 7)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraLarge, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 15, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 44)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraExtraLarge, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 52)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 17, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 50)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 8)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheExtraExtraExtraLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .extraExtraExtraLarge, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 58)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 19, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 56)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 9)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 15)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityMediumContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityMedium, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 69)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 23, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 72)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityLarge, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 81)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 27, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 84)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 11)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraLarge, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 97)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 33, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 105)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 14)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraExtraLarge, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 114)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 38, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 124)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 17)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheExpectedMetricsForTheAccessibilityExtraExtraExtraLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .accessibilityExtraExtraExtraLarge, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, 127)
        XCTAssertEqual(metrics.sectionHeaderFont, .systemFont(ofSize: 44, weight: .regular))
        XCTAssertEqual(metrics.sectionHeaderHeight, 142)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, 18)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), 10)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), 18)
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), 38)
    }
    
    func testItReturnsTheSameMetricsForTheUnsepcifiedContentSizeCategoryAsForTheLargeContentSizeCategoryOniPad() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .unspecified, userInterfaceIdiom: .pad)
        let largeMetrics = displayMetrics(forPreferredContentSizeCategory: .large, userInterfaceIdiom: .pad)
        XCTAssertEqual(metrics.cellHeight, largeMetrics.cellHeight)
        XCTAssertEqual(metrics.sectionHeaderFont, largeMetrics.sectionHeaderFont)
        XCTAssertEqual(metrics.sectionHeaderHeight, largeMetrics.sectionHeaderHeight)
        XCTAssertEqual(metrics.sectionHeaderLabelBottomPadding, largeMetrics.sectionHeaderLabelBottomPadding)
        XCTAssertEqual(metrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5), largeMetrics.leadingSeparatorInset(forLeadingLayoutMargin: 10, cellContentInset: 5))
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: false), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: false))
        XCTAssertEqual(metrics.sectionBottomPadding(forSectionThatIsTheLastSection: true), largeMetrics.sectionBottomPadding(forSectionThatIsTheLastSection: true))
    }
}

// MARK: - Text Colours
extension TableStyleDisplayMetricsTests {
    func testItReturnsTheCorrectHeaderTextColourInLightInterfaceStyle() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .large, userInterfaceIdiom: .phone)
        performTest(withUserInterfaceStyle: .light) {
            XCTAssertEqual(metrics.sectionHeaderTextColour.cgColor, UIColor(red: 0.43, green: 0.43, blue: 0.45, alpha: 1).cgColor)
        }
    }
    
    func testItReturnsTheCorrectHeaderTextColourInDarkInterfaceStyle() {
        givenDisplayMetrics(forPreferredContentSizeCategory: .large, userInterfaceIdiom: .phone)
        performTest(withUserInterfaceStyle: .dark) {
            XCTAssertEqual(metrics.sectionHeaderTextColour.cgColor, UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1).cgColor)
        }
    }
}
