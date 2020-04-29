//
//  RegionNameRowController.swift
//  Counties Extension
//
//  Created by Stephen Anthony on 13/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import WatchKit
import CountiesModel

/// The row controller responsible for showing county information in a table row
class RegionNameRowController: NSObject {
    @IBOutlet private weak var nameLabel: WKInterfaceLabel!
    
    /// The region represented by the receiver.
    var region: Region? {
        didSet {
            nameLabel.setText(region?.name)
        }
    }
}

