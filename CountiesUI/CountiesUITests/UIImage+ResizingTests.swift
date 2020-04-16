//
//  UIImage+ResizingTests.swift
//  CountiesUITests
//
//  Created by Stephen Anthony on 16/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesUI

final class UIImageResizingTests: XCTestCase {
    private var sourceImage: UIImage!
    private var resizedImage: UIImage!
    
    override func tearDown() {
        sourceImage = nil
        resizedImage = nil
        super.tearDown()
    }
    
    private func givenSourceImage(ofSize size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIColor.black.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        sourceImage = image
    }
    
    private func whenTheSourceImage(isResizedTo size: CGSize) {
        resizedImage = sourceImage.resized(toFit: size)
    }
}

// MARK: - Landscape Source Images
extension UIImageResizingTests {
    func testItResizesALandscapeImageToASquareSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 300, height: 200))
        whenTheSourceImage(isResizedTo: CGSize(width: 100, height: 100))
        XCTAssertEqual(resizedImage.size.width, 150)
        XCTAssertEqual(resizedImage.size.height, 100)
    }
    
    func testItResizesALandscapeImageToALandscapeSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 300, height: 200))
        whenTheSourceImage(isResizedTo: CGSize(width: 200, height: 100))
        XCTAssertEqual(resizedImage.size.width, 200)
        XCTAssertEqual(resizedImage.size.height, 133.333, accuracy: 0.001)
    }
    
    func testItResizesALandscapeImageToAPortraitSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 300, height: 200))
        whenTheSourceImage(isResizedTo: CGSize(width: 100, height: 150))
        XCTAssertEqual(resizedImage.size.width, 225)
        XCTAssertEqual(resizedImage.size.height, 150)
    }
}

// MARK: - Portrait Source Images
extension UIImageResizingTests {
    func testItResizesAPortraitImageToASquareSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 200, height: 300))
        whenTheSourceImage(isResizedTo: CGSize(width: 50, height: 50))
        XCTAssertEqual(resizedImage.size.width, 50)
        XCTAssertEqual(resizedImage.size.height, 75)
    }
    
    func testItResizesAPortraitImageToALandscapeSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 200, height: 300))
        whenTheSourceImage(isResizedTo: CGSize(width: 175, height: 100))
        XCTAssertEqual(resizedImage.size.width, 175)
        XCTAssertEqual(resizedImage.size.height, 262.666, accuracy: 0.001)
    }
    
    func testItResizesAPortraitImageToAPortraitSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 200, height: 300))
        whenTheSourceImage(isResizedTo: CGSize(width: 60, height: 75))
        XCTAssertEqual(resizedImage.size.width, 60)
        XCTAssertEqual(resizedImage.size.height, 90)
    }
}

// MARK: - Square Source Images
extension UIImageResizingTests {
    func testItResizesASquareImageToASquareSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 200, height: 200))
        whenTheSourceImage(isResizedTo: CGSize(width: 50, height: 50))
        XCTAssertEqual(resizedImage.size.width, 50)
        XCTAssertEqual(resizedImage.size.height, 50)
    }
    
    func testItResizesASquareImageToALandscapeSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 200, height: 200))
        whenTheSourceImage(isResizedTo: CGSize(width: 120, height: 60))
        XCTAssertEqual(resizedImage.size.width, 120)
        XCTAssertEqual(resizedImage.size.height, 120)
    }
    
    func testItResizesASquareImageToAPortraitSizeAsExpected() {
        givenSourceImage(ofSize: CGSize(width: 200, height: 200))
        whenTheSourceImage(isResizedTo: CGSize(width: 120, height: 180))
        XCTAssertEqual(resizedImage.size.width, 180)
        XCTAssertEqual(resizedImage.size.height, 180)
    }
}
