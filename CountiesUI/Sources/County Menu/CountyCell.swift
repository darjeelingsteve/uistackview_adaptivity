//
//  CountyCell.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesModel

/*!
The styles that the cell can display itself in.
- Table: Display the cell in a table style.
- Grid:  Display the cell in a grid style.
*/
enum CountyCellDisplayStyle {
    case table
    case grid
}

private struct BorderSettings {
    let width: CGFloat
    let cornerRadius: CGFloat
    #if os(tvOS)
    let colour = UIColor.clear
    #else
    let colour = UIColor.secondarySystemBackground
    #endif
}

/// The cell responsible for displaying County data.
class CountyCell: UICollectionViewCell {
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
    
    private let nameLabel: UILabel = {
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
        flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        flagImageView.widthAnchor.constraint(equalToConstant: 100),
        flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 2 / 3, constant: 0),
        nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: flagImageView.trailingAnchor, multiplier: 1),
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
                flagImageView.image = county.flagImage
            }
        }
    }
    
    /// The display style of the receiver.
    var displayStyle: CountyCellDisplayStyle = .table {
        didSet {
            flagImageView.layer.cornerRadius = borderSettings.cornerRadius
            nameLabel.font = .preferredFont(forTextStyle: displayStyle.nameLabelTextStyle)
            nameLabel.textAlignment = displayStyle.nameLabelTextAlignment
            selectedBackgroundView?.layer.cornerRadius = borderSettings.cornerRadius
            setNeedsUpdateConstraints()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            // Only show the flag overlay if we are highlighted and in grid style.
            selectionFlagOverlayView.isHidden = !isHighlighted || displayStyle == .table
        }
    }
    
    private var borderSettings: BorderSettings {
        switch (displayStyle) {
        case .table:
            return BorderSettings(width: 1.0, cornerRadius: 0)
        case .grid:
            return BorderSettings(width: 0.0, cornerRadius: 10)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if os(iOS)
        backgroundColor = .systemBackground
        #endif
        contentView.addSubview(nameLabel)
        contentView.addSubview(flagImageView)
        flagImageView.addSubview(selectionFlagOverlayView)
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = borderSettings.colour
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
        
        switch (displayStyle) {
        case .table:
            NSLayoutConstraint.activate(tableStyleConstraits)
            NSLayoutConstraint.deactivate(gridStyleConstraits)
        case .grid:
            NSLayoutConstraint.activate(gridStyleConstraits)
            NSLayoutConstraint.deactivate(tableStyleConstraits)
        }
        
        super.updateConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path: UIBezierPath
        let lineWidth = borderSettings.width
        switch (displayStyle) {
        case .table:
            path = UIBezierPath()
            path.move(to: CGPoint(x: layoutMargins.left, y: rect.maxY - lineWidth))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - lineWidth))
        case .grid:
            path = UIBezierPath(roundedRect: rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2), cornerRadius: borderSettings.cornerRadius)
        }
        
        path.lineWidth = lineWidth
        borderSettings.colour.set()
        path.stroke()
    }
}

private extension CountyCellDisplayStyle {
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
}
