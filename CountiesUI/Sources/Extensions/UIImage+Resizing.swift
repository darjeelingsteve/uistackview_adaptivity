//
//  UIImage+Resizing.swift
//  CountiesUI iOS
//
//  Created by Stephen Anthony on 16/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Resizes the receiver to fit the given size. If the reciever's aspect
    /// ratio is different to that of the given size, the receiver is resized to
    /// "aspectFill" the given size i.e the resized image will be larger than
    /// the given size, but will have an equal dimension to the given size's
    /// smallest dimension.
    /// - Parameter size: The target size to resize the receiver to.
    /// - Returns: A resized version of the receiver.
    func resized(toFit size: CGSize) -> UIImage {
        let widthMultipler = size.width / self.size.width
        let heightMultipler = size.height / self.size.height
        let largestMultipler = max(widthMultipler, heightMultipler)
        
        let resizedSize = CGSize(width: self.size.width * largestMultipler, height: self.size.height * largestMultipler)
        let renderer = UIGraphicsImageRenderer(size: resizedSize)
        return renderer.image { (_) in
            draw(in: CGRect(origin: .zero, size: resizedSize))
        }
    }
}
