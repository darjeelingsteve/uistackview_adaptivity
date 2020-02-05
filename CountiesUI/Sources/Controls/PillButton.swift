//
//  PillButton.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 20/12/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import UIKit

/// A button subclass that draws a tint coloured pill as its background.
@IBDesignable class PillButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width + 24, height: superSize.height)
    }
    
    private var drawingColour: UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        guard tintColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return tintColor
        }
        if isHighlighted {
            return UIColor(hue: hue, saturation: saturation - 0.1, brightness: brightness - 0.25, alpha: alpha)
        }
        return tintColor
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
        drawingColour.set()
        UIBezierPath(roundedRect: rect, cornerRadius: floor(bounds.height / 2)).fill()
        super.draw(rect)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }
    
    private func commonSetup() {
        addTarget(self, action: #selector(stateChanged), for: .allTouchEvents)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    @objc private func stateChanged() {
        setNeedsDisplay()
    }
}
