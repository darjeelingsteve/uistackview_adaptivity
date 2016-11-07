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
    static let width: CGFloat = 1.0 / UIScreen.main.scale
    static let colour = UIColor(white: 0.9, alpha: 1.0)
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
        switch (displayStyle) {
        case .table:
            path = UIBezierPath()
            path.move(to: CGPoint(x: layoutMargins.left, y: rect.maxY - BorderSettings.width))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - BorderSettings.width))
        case .grid:
            path = UIBezierPath(rect: rect)
        }
        
        path.lineWidth = BorderSettings.width;
        BorderSettings.colour.set()
        path.stroke()
    }
}
