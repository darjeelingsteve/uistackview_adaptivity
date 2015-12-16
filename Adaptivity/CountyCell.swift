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
    case Table
    case Grid
}

private struct BorderSettings {
    static let width: CGFloat = 1.0 / UIScreen.mainScreen().scale
    static let colour = UIColor(white: 0.9, alpha: 1.0)
}

/// The cell responsible for displaying County data.
class CountyCell: UICollectionViewCell {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var displayStyle: CountyCellDisplayStyle = .Table {
        didSet {
            switch (displayStyle) {
            case .Table:
                stackView.axis = .Horizontal
            case .Grid:
                stackView.axis = .Vertical
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
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let path: UIBezierPath
        switch (displayStyle) {
        case .Table:
            path = UIBezierPath()
            path.moveToPoint(CGPoint(x: layoutMargins.left, y: CGRectGetMaxY(rect) - BorderSettings.width))
            path.addLineToPoint(CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect) - BorderSettings.width))
        case .Grid:
            path = UIBezierPath(rect: rect)
        }
        
        path.lineWidth = BorderSettings.width;
        UIColor.lightGrayColor().set()
        path.stroke()
    }
}
