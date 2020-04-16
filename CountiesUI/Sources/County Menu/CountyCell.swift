//
//  CountyCell.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesModel

/// The cell responsible for displaying County data.
class CountyCell: UICollectionViewCell {
    
    /// The styles that the cell can display itself in.
    ///
    /// - table: Display the cell in a table style.
    /// - grid:  Display the cell in a grid style.
    enum DisplayStyle {
        case table
        case grid
    }
    
    /// The position of the cell in its parent section.
    ///
    /// - first: The cell represents the first item in a multi-item section.
    /// - middle: The cell represents an item in a multi-item section with more
    /// than two items, and does not represent the first or last item.
    /// - last: The cell represents the last item in a multi-item section.
    /// - singleItem: The cell represents the only item in a section.
    enum SectionPosition {
        case first
        case middle
        case last
        case singleItem
    }
    
    private let flagImageView: UIImageView = {
        let flagImageView = UIImageView()
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.contentMode = .scaleAspectFill
        flagImageView.layer.cornerCurve = .continuous
        #if os(tvOS)
        flagImageView.adjustsImageWhenAncestorFocused = true
        #elseif os(iOS)
        flagImageView.clipsToBounds = true
        #endif
        return flagImageView
    }()
    
    fileprivate let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return nameLabel
    }()
    
    private let selectionFlagOverlayView: UIView = {
        let selectionFlagOverlayView = UIView()
        selectionFlagOverlayView.translatesAutoresizingMaskIntoConstraints = false
        selectionFlagOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        selectionFlagOverlayView.isHidden = true
        return selectionFlagOverlayView
    }()
    
    private lazy var tableStyleConstraits: [NSLayoutConstraint] = [
        flagImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        flagImageView.widthAnchor.constraint(equalToConstant: 29),
        flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 1),
        flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 12),
        nameLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ]
    
    private lazy var gridStyleConstraits: [NSLayoutConstraint] = [
        flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        nameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        nameLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: flagImageView.bottomAnchor, multiplier: gridStyleNameLabelSpacingMultiplier),
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ]
    
    private var gridStyleNameLabelSpacingMultiplier: CGFloat {
        return platformValue(foriOS: 1, tvOS: 4)
    }
    
    /// The county to be displayed by the cell.
    var county: County? {
        didSet {
            if let county = county {
                nameLabel.text = county.name
                flagImageView.image = county.flagImageThumbnail
            }
        }
    }
    
    /// The display style of the receiver.
    var displayStyle: DisplayStyle = .table {
        didSet {
            flagImageView.layer.cornerRadius = displayStyle.flagCornerRadius
            nameLabel.font = .preferredFont(forTextStyle: displayStyle.nameLabelTextStyle)
            nameLabel.textAlignment = displayStyle.nameLabelTextAlignment
            selectedBackgroundView?.layer.cornerRadius = displayStyle.borderSettings.cornerRadius
            backgroundColor = displayStyle.backgroundColour
            setNeedsUpdateConstraints()
        }
    }
    
    /// The position of the cell in its parent section.
    var sectionPosition: SectionPosition = .singleItem {
        didSet {
            setNeedsDisplay() // Redraw the border
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            // Only show the flag overlay if we are highlighted and in grid style.
            selectionFlagOverlayView.isHidden = !isHighlighted || displayStyle == .table
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(flagImageView)
        flagImageView.addSubview(selectionFlagOverlayView)
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = displayStyle.borderSettings.colour
        selectedBackgroundView?.layer.cornerCurve = .continuous
        clipsToBounds = false
        contentView.clipsToBounds = false
        contentView.preservesSuperviewLayoutMargins = true
        preservesSuperviewLayoutMargins = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay() // Redraw the border
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            selectionFlagOverlayView.leadingAnchor.constraint(equalTo: flagImageView.leadingAnchor),
            selectionFlagOverlayView.trailingAnchor.constraint(equalTo: flagImageView.trailingAnchor),
            selectionFlagOverlayView.topAnchor.constraint(equalTo: flagImageView.topAnchor),
            selectionFlagOverlayView.bottomAnchor.constraint(equalTo: flagImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.deactivate(tableStyleConstraits)
        NSLayoutConstraint.deactivate(gridStyleConstraits)
        
        switch displayStyle {
        case .table:
            NSLayoutConstraint.activate(tableStyleConstraits)
        case .grid:
            NSLayoutConstraint.activate(gridStyleConstraits)
        }
        
        super.updateConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let borderPath = sectionPosition.borderPath(in: self) else { return }
        displayStyle.borderSettings.colour.set()
        borderPath.stroke()
    }
}

private extension CountyCell.DisplayStyle {
    var nameLabelTextStyle: UIFont.TextStyle {
        switch self {
        case .table:
            return .body
        case .grid:
            return .headline
        }
    }
    
    var nameLabelTextAlignment: NSTextAlignment {
        switch self {
        case .table:
            return .left
        case .grid:
            return .center
        }
    }
    
    var flagCornerRadius: CGFloat {
        switch self {
        case .table:
            return 4
        case .grid:
            return borderSettings.cornerRadius
        }
    }
    
    var borderSettings: BorderSettings {
        switch self {
        case .table:
            return BorderSettings(width: 1.0, cornerRadius: 0)
        case .grid:
            return BorderSettings(width: 0.0, cornerRadius: 10)
        }
    }
    
    var backgroundColour: UIColor {
        #if os(iOS)
        switch self {
        case .table:
            return .secondarySystemGroupedBackground
        case .grid:
            return .clear
        }
        #elseif os(tvOS)
        return .clear
        #endif
    }
}

private extension CountyCell.SectionPosition {
    func borderPath(in cell: CountyCell) -> UIBezierPath? {
        switch cell.displayStyle {
        case .table:
            let lineWidth = cell.displayStyle.borderSettings.width / cell.traitCollection.displayScale
            let rect = cell.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
            let path = UIBezierPath()
            switch self {
            case .first:
                addCellTopBorder(to: path, in: rect)
                addTableCellBottomBorder(to: path, in: rect, leftInset: cell.nameLabel.frame.origin.x)
            case .middle:
                addTableCellBottomBorder(to: path, in: rect, leftInset: cell.nameLabel.frame.origin.x)
            case .last:
                addTableCellBottomBorder(to: path, in: rect)
            case .singleItem:
                addCellTopBorder(to: path, in: rect)
                addTableCellBottomBorder(to: path, in: rect)
            }
            path.lineWidth = lineWidth
            path.lineCapStyle = .square
            return path
        case .grid:
            return nil
        }
    }
    
    private func addCellTopBorder(to path: UIBezierPath, in rect: CGRect) {
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    }
    
    private func addTableCellBottomBorder(to path: UIBezierPath, in rect: CGRect, leftInset: CGFloat = 0) {
        path.move(to: CGPoint(x: rect.minX + leftInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    }
}

private struct BorderSettings {
    let width: CGFloat
    let cornerRadius: CGFloat
    #if os(tvOS)
    let colour = UIColor.clear
    #else
    let colour = UIColor.separator
    #endif
}
