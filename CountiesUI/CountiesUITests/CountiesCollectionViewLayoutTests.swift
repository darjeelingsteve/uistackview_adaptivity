//
//  CountiesCollectionViewLayoutTests.swift
//  CountiesUITests
//
//  Created by Stephen Anthony on 20/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import XCTest
@testable import CountiesUI

final class CountiesCollectionViewLayoutTests: XCTestCase {
    private var countiesCollectionViewLayout: CountiesCollectionViewLayout!
    private var collectionView: TraitCollectionCollectionView!
    private var generatedSeparatorAttributes: [TableCellStyleSeparatorAttributes]!
    private var numberOfItems = 4

    override func setUp() {
        super.setUp()
        countiesCollectionViewLayout = CountiesCollectionViewLayout()
        collectionView = TraitCollectionCollectionView(frame: CGRect(x: 0, y: 0, width: 375, height: 600), collectionViewLayout: countiesCollectionViewLayout)
        collectionView.dataSource = self
    }

    override func tearDown() {
        countiesCollectionViewLayout = nil
        collectionView = nil
        generatedSeparatorAttributes = nil
        super.tearDown()
    }
    
    private func givenTheLayoutIsInTableStyle(withLeadingSeparatorInset leadingSeparatorInset: CGFloat, cellHeight: CGFloat) {
        countiesCollectionViewLayout.itemSize = CGSize(width: collectionView.bounds.width, height: cellHeight)
        countiesCollectionViewLayout.style = .table(leadingSeparatorInset: leadingSeparatorInset)
    }
    
    private func givenTheLayoutIsInGridStyle() {
        countiesCollectionViewLayout.itemSize = CGSize(width: 50, height: 50)
        countiesCollectionViewLayout.style = .grid
    }
    
    private func givenTheCollectionView(hasAScaleOf scale: CGFloat) {
        collectionView.scale = scale
    }
    
    private func givenTheNumberOfItems(is numberOfItems: Int) {
        self.numberOfItems = numberOfItems
    }
    
    private func whenTheLayoutIsAskedForLayoutAttributes() {
        generatedSeparatorAttributes = countiesCollectionViewLayout.layoutAttributesForElements(in: collectionView.bounds)!.compactMap { $0 as? TableCellStyleSeparatorAttributes }
    }

    func testItAppliesTheCorrectMetricsInTableStyle() {
        let leadingSeparatorInset: CGFloat = 20
        let cellHeight: CGFloat = 50
        givenTheLayoutIsInTableStyle(withLeadingSeparatorInset: leadingSeparatorInset, cellHeight: cellHeight)
        whenTheLayoutIsAskedForLayoutAttributes()
        XCTAssertEqual(generatedSeparatorAttributes.count, 4)
        
        XCTAssertEqual(generatedSeparatorAttributes[0].drawingMetrics?.leadingSeparatorInset, leadingSeparatorInset)
        XCTAssertEqual(generatedSeparatorAttributes[0].drawingMetrics?.sectionPosition, .first)
        XCTAssertEqual(generatedSeparatorAttributes[0].frame, CGRect(x: 0,
                                                                     y: 0,
                                                                     width: collectionView.bounds.width,
                                                                     height: cellHeight))
        XCTAssertEqual(generatedSeparatorAttributes[1].drawingMetrics?.leadingSeparatorInset, leadingSeparatorInset)
        XCTAssertEqual(generatedSeparatorAttributes[1].drawingMetrics?.sectionPosition, .middle)
        XCTAssertEqual(generatedSeparatorAttributes[1].frame, CGRect(x: 0,
                                                                     y: 50,
                                                                     width: collectionView.bounds.width,
                                                                     height: cellHeight))
        XCTAssertEqual(generatedSeparatorAttributes[2].drawingMetrics?.leadingSeparatorInset, leadingSeparatorInset)
        XCTAssertEqual(generatedSeparatorAttributes[2].drawingMetrics?.sectionPosition, .middle)
        XCTAssertEqual(generatedSeparatorAttributes[2].frame, CGRect(x: 0,
                                                                     y: 100,
                                                                     width: collectionView.bounds.width,
                                                                     height: cellHeight))
        XCTAssertEqual(generatedSeparatorAttributes[3].drawingMetrics?.leadingSeparatorInset, leadingSeparatorInset)
        XCTAssertEqual(generatedSeparatorAttributes[3].drawingMetrics?.sectionPosition, .last)
        XCTAssertEqual(generatedSeparatorAttributes[3].frame, CGRect(x: 0,
                                                                     y: 150,
                                                                     width: collectionView.bounds.width,
                                                                     height: cellHeight))
    }
    
    func testItAppliesTheCorrectMetricsInTableStyleWithASingleItem() {
        let leadingSeparatorInset: CGFloat = 20
        let cellHeight: CGFloat = 50
        givenTheLayoutIsInTableStyle(withLeadingSeparatorInset: leadingSeparatorInset, cellHeight: cellHeight)
        givenTheNumberOfItems(is: 1)
        whenTheLayoutIsAskedForLayoutAttributes()
        XCTAssertEqual(generatedSeparatorAttributes.count, 1)
        
        XCTAssertEqual(generatedSeparatorAttributes[0].drawingMetrics?.leadingSeparatorInset, leadingSeparatorInset)
        XCTAssertEqual(generatedSeparatorAttributes[0].drawingMetrics?.sectionPosition, .singleItem)
        XCTAssertEqual(generatedSeparatorAttributes[0].frame, CGRect(x: 0,
                                                                     y: 0,
                                                                     width: collectionView.bounds.width,
                                                                     height: cellHeight))
    }
    
    func testItUsesTheCorrectSeparatorHeight() {
        givenTheLayoutIsInTableStyle(withLeadingSeparatorInset: 20, cellHeight: 50)
        givenTheCollectionView(hasAScaleOf: 1)
        whenTheLayoutIsAskedForLayoutAttributes()
        XCTAssertEqual(generatedSeparatorAttributes[0].drawingMetrics?.separatorWeight, 1)
        
        givenTheCollectionView(hasAScaleOf: 2)
        whenTheLayoutIsAskedForLayoutAttributes()
        XCTAssertEqual(generatedSeparatorAttributes[0].drawingMetrics?.separatorWeight, 0.5)
    }
    
    func testItDefaultsToNoItemOrLineSpacing() {
        XCTAssertEqual(countiesCollectionViewLayout.minimumInteritemSpacing, 0)
        XCTAssertEqual(countiesCollectionViewLayout.minimumLineSpacing, 0)
    }
    
    func testItDoesNotApplySeparatorMetricsInGridStyle() {
        givenTheLayoutIsInGridStyle()
        whenTheLayoutIsAskedForLayoutAttributes()
        XCTAssertEqual(generatedSeparatorAttributes.count, 0)
    }
}

extension CountiesCollectionViewLayoutTests: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
}

private class TraitCollectionCollectionView: UICollectionView {
    var scale: CGFloat = 1.0

    override var traitCollection: UITraitCollection {
        return UITraitCollection(displayScale: scale)
    }
}
