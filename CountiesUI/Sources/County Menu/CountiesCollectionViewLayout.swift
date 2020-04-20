//
//  CountiesCollectionViewLayout.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 20/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The collection view layout used to layout the counties menu collection view.
final class CountiesCollectionViewLayout: UICollectionViewFlowLayout {
    /// The style that the layout will be computed for.
    var style = Style.table(leadingSeparatorInset: 0) {
        didSet {
            if style != oldValue {
                invalidateLayout()
            }
        }
    }
    
    private var separatorWeight: CGFloat {
        return 1.0 / scale
    }
    
    private var scale: CGFloat {
        guard let scale = collectionView?.traitCollection.displayScale, scale > 0 else {
            return UIScreen.main.scale
        }
        return scale
    }
    
    override init() {
        super.init()
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override func prepare() {
        super.prepare()
        register(TableCellStyleSeparatorView.self, forDecorationViewOfKind: TableCellStyleSeparatorView.kind)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, var attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        let cellAttributes = attributes.filter { $0.representedElementCategory == .cell }
        if let separatorAttributes = style.separatorAttributes(from: cellAttributes, in: collectionView, separatorWeight: separatorWeight) {
            attributes.append(contentsOf: separatorAttributes)
        }
        return attributes
    }
    
    private func commonSetup() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    /// The different styles of adaptive table layout.
    ///
    /// - table: The list will be laid out as a single column table.
    /// - grid: The list will be laid out as a multi-column grid.
    enum Style: Equatable {
        case table(leadingSeparatorInset: CGFloat)
        case grid
        
        fileprivate func separatorAttributes(from attributes: [UICollectionViewLayoutAttributes], in collectionView: UICollectionView, separatorWeight: CGFloat) -> [UICollectionViewLayoutAttributes]? {
            switch self {
            case let .table(leadingSeparatorInset):
                return tableSeparators(for: attributes, in: collectionView, withLeadingSeparatorInset: leadingSeparatorInset, separatorWeight: separatorWeight)
            case .grid:
                return nil
            }
        }
        
        private func tableSeparators(for attributes: [UICollectionViewLayoutAttributes], in collectionView: UICollectionView, withLeadingSeparatorInset leadingSeparatorInset: CGFloat, separatorWeight: CGFloat) -> [UICollectionViewLayoutAttributes] {
            return attributes.map {
                let separatorAttributes = TableCellStyleSeparatorAttributes(forDecorationViewOfKind: TableCellStyleSeparatorView.kind, with: $0.indexPath)
                separatorAttributes.frame = $0.frame
                let sectionPosition = self.sectionPosition(forCellAt: $0.indexPath, in: collectionView)
                separatorAttributes.drawingMetrics = TableCellStyleSeparatorView.DrawingMetrics(sectionPosition: sectionPosition, leadingSeparatorInset: leadingSeparatorInset, separatorWeight: separatorWeight)
                separatorAttributes.zIndex = 10000 // Make sure separators appear above cells
                return separatorAttributes
            }
        }
        
        private func sectionPosition(forCellAt indexPath: IndexPath, in collectionView: UICollectionView) -> TableCellStyleSeparatorView.DrawingMetrics.SectionPosition {
            switch indexPath.item {
            case 0:
                let isSingleItemSection = collectionView.numberOfItems(inSection: indexPath.section) == 1
                return isSingleItemSection ? .singleItem : .first
            case collectionView.numberOfItems(inSection: indexPath.section) - 1:
                return .last
            default:
                return .middle
            }
        }
    }
}
