//
//  CountyRowController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import WatchKit
import CountiesModel

/// The row controller responsible for showing county information in a table row
class CountyRowController: NSObject {
    @IBOutlet fileprivate weak var nameLabel: WKInterfaceLabel!
    @IBOutlet fileprivate weak var flagImage: WKInterfaceImage!
    
    var county: County? {
        didSet {
            nameLabel.setText(county?.name)
            flagImage.setImage(county?.flagImage)
        }
    }
}
