//
//  TableCellStyleSeparatorView.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 20/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The view used to draw separators in the collection view. The view expects to
/// cover an individual cell entirely, and draws separators as appropriate
/// according to the position of the cell it covers in the collection view.
final class TableCellStyleSeparatorView: UICollectionReusableView {
    static let kind = "Separator"
    private let separatorsView = SeparatorsView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard layoutAttributes.frame.origin.x.isNaN == false, layoutAttributes.frame.origin.y.isNaN == false else {
            return
        }
        frame = layoutAttributes.frame
        separatorsView.drawingMetrics = (layoutAttributes as? TableCellStyleSeparatorAttributes)?.drawingMetrics
    }

    private func commonSetup() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        separatorsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorsView)
        NSLayoutConstraint.activate([
            separatorsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorsView.topAnchor.constraint(equalTo: topAnchor),
            separatorsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// The attributes used to draw the separators for a particular separator
    /// view.
    struct DrawingMetrics: Equatable {
        let indexPath: IndexPath
        let indexPathForHighlightedItem: IndexPath?
        let sectionPosition: SectionPosition
        let leadingSeparatorInset: CGFloat
        let separatorWeight: CGFloat
        
        /// The position of the cell in its parent section that the separator
        /// view draws separators for.
        ///
        /// - first: The cell represents the first item in a multi-item section.
        /// - middle: The cell represents an item in a multi-item section with
        /// more than two items, and does not represent the first or last item.
        /// - last: The cell represents the last item in a multi-item section.
        /// - singleItem: The cell represents the only item in a section.
        enum SectionPosition {
            case first
            case middle
            case last
            case singleItem
        }
    }
}

/// The layout attributes to apply to `TableCellStyleSeparatorView`.
final class TableCellStyleSeparatorAttributes: UICollectionViewLayoutAttributes {
    var drawingMetrics: TableCellStyleSeparatorView.DrawingMetrics?

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? TableCellStyleSeparatorAttributes else {
            return super.isEqual(object)
        }
        return super.isEqual(other) && drawingMetrics == other.drawingMetrics
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        (copy as? TableCellStyleSeparatorAttributes)?.drawingMetrics = drawingMetrics
        return copy
    }
}

/// A view that draws separators according to a specific set of drawing metrics.
private final class SeparatorsView: UIView {
    var drawingMetrics: TableCellStyleSeparatorView.DrawingMetrics? {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let drawingMetrics = drawingMetrics else { return }
        UIColor.separator.setStroke()
        drawingMetrics.sectionPosition.borderPath(in: rect,
                                                  cellIndexPath: drawingMetrics.indexPath,
                                                  indexPathForHighlightedItem: drawingMetrics.indexPathForHighlightedItem,
                                                  leadingSeparatorInset: drawingMetrics.leadingSeparatorInset,
                                                  separatorWeight: drawingMetrics.separatorWeight)?.stroke()
    }

    private func commonSetup() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
}

private extension TableCellStyleSeparatorView.DrawingMetrics.SectionPosition {
    func borderPath(in rect: CGRect, cellIndexPath: IndexPath, indexPathForHighlightedItem: IndexPath?, leadingSeparatorInset: CGFloat, separatorWeight: CGFloat) -> UIBezierPath? {
        guard cellIndexPath != indexPathForHighlightedItem else {
            // Don't draw any separators for highlighted cells
            return nil
        }
        let insetRect = rect.insetBy(dx: separatorWeight / 2, dy: separatorWeight / 2)
        let path = UIBezierPath()
        switch self {
        case .first:
            addTableCellTopBorder(to: path, in: insetRect)
            fallthrough
        case .middle:
            /*
             Only draw the separator dividing this cell with the one below if
             the one below is not highlighted.
             */
            let cellBelowIsHighlighted = cellIndexPath.representsItem(before: indexPathForHighlightedItem)
            if cellBelowIsHighlighted == false {
                addTableCellBottomBorder(to: path, in: insetRect, leftInset: leadingSeparatorInset)
            }
        case .last:
            addTableCellBottomBorder(to: path, in: insetRect)
        case .singleItem:
            addTableCellTopBorder(to: path, in: insetRect)
            addTableCellBottomBorder(to: path, in: insetRect)
        }
        path.lineWidth = separatorWeight
        path.lineCapStyle = .square
        return path
    }
    
    private func addTableCellTopBorder(to path: UIBezierPath, in rect: CGRect) {
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    }
    
    private func addTableCellBottomBorder(to path: UIBezierPath, in rect: CGRect, leftInset: CGFloat = 0) {
        path.move(to: CGPoint(x: rect.minX + leftInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    }
}

private extension IndexPath {
    func representsItem(before indexPath: IndexPath?) -> Bool {
        guard let indexPath = indexPath else { return false }
        return item == indexPath.item - 1 && section == indexPath.section
    }
}
