//
//  CountyCell.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit

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
    static func width(forStyle style: CountyCellDisplayStyle) -> CGFloat {
        switch style {
        case .table:
            return 1.0 / UIScreen.main.scale
        case .grid:
            return 3.0
        }
    }
    static let colour = UIColor.secondarySystemBackground
}

/// The cell responsible for displaying County data.
class CountyCell: UICollectionViewCell {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    /// The display style of the receiver.
    var displayStyle: CountyCellDisplayStyle = .table {
        didSet {
            switch (displayStyle) {
            case .table:
                stackView.axis = .horizontal
            case .grid:
                stackView.axis = .vertical
            }
        }
    }
    
    /// The county to be displayed by the cell.
    var county: County? {
        didSet {
            if let county = county {
                nameLabel.text = county.name
                flagImageView.image = UIImage(named: county.name)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = BorderSettings.colour
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay() // Redraw the border
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path: UIBezierPath
        let lineWidth = BorderSettings.width(forStyle: displayStyle)
        switch (displayStyle) {
        case .table:
            path = UIBezierPath()
            path.move(to: CGPoint(x: layoutMargins.left, y: rect.maxY - lineWidth))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - lineWidth))
        case .grid:
            path = UIBezierPath(rect: rect)
        }
        
        path.lineWidth = lineWidth
        BorderSettings.colour.set()
        path.stroke()
    }
}
