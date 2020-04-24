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
    static var tableCellStyleNameLabelLeadingPadding: CGFloat = CountyCell.tableCellStyleFlagImageWidth + 15
    private static let tableCellStyleFlagImageWidth: CGFloat = 29
    
    /// The styles that the cell can display itself in.
    ///
    /// - table: Display the cell in a table style.
    /// - grid:  Display the cell in a grid style.
    enum DisplayStyle {
        case table
        case grid
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
    
    private let chevronImageView: UIImageView = {
        let chevronImage = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(textStyle: .headline, scale: .small))
        let chevronImageView = UIImageView(image: chevronImage)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.tintColor = .placeholderText
        chevronImageView.tintAdjustmentMode = .normal
        chevronImageView.setContentHuggingPriority(.required, for: .horizontal)
        chevronImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return chevronImageView
    }()
    
    private lazy var tableStyleConstraits: [NSLayoutConstraint] = [
        flagImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        flagImageView.widthAnchor.constraint(equalToConstant: CountyCell.tableCellStyleFlagImageWidth),
        flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 1),
        flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        nameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: CountyCell.tableCellStyleNameLabelLeadingPadding),
        nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        chevronImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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
            selectedBackgroundView?.layer.cornerRadius = displayStyle.selectedBackgroundViewCornerRadius
            backgroundColor = displayStyle.backgroundColour
            configureSubviewsForCurrentDisplayStyle()
            setNeedsUpdateConstraints()
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
        configureSubviewsForCurrentDisplayStyle()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .separator
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
    
    private func configureSubviewsForCurrentDisplayStyle() {
        switch displayStyle {
        case .table:
            contentView.addSubview(chevronImageView)
        case .grid:
            chevronImageView.removeFromSuperview()
        }
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
    
    var selectedBackgroundViewCornerRadius: CGFloat {
        switch self {
        case .table:
            return 0
        case .grid:
            return flagCornerRadius
        }
    }
    
    var flagCornerRadius: CGFloat {
        switch self {
        case .table:
            return 7
        case .grid:
            return 10
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
