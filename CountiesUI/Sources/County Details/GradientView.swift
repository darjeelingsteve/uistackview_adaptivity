//
//  GradientView.swift
//  CountiesUITests
//
//  Created by Stephen Anthony on 25/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// A view that draws a vertical gradient.
@IBDesignable class GradientView: UIView {
    
    /// The colour at the top of the gradient.
    @IBInspectable var topColour: UIColor? {
        didSet {
            configureGradient()
        }
    }
    
    /// The colour at the bottom of the gradient.
    @IBInspectable var bottomColour: UIColor? {
        didSet {
            configureGradient()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    private func configureGradient() {
        gradientLayer.colors = [topColour.clearifNil, bottomColour.clearifNil].map { $0.cgColor }
    }
}

private extension Optional where Wrapped == UIColor {
    var clearifNil: UIColor {
        switch self {
        case .some(let colour):
            return colour
        case .none:
            return UIColor.clear
        }
    }
}
