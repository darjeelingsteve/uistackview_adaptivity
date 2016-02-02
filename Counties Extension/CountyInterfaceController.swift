//
//  CountyInterfaceController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import WatchKit
import Foundation

/// The interface controller responsible for displaying county details in an interface controller
class CountyInterfaceController: WKInterfaceController {
    @IBOutlet private weak var flagImage: WKInterfaceImage!
    @IBOutlet private weak var nameLabel: WKInterfaceLabel!
    @IBOutlet private weak var populationLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        guard let countyName = context as? String else {
            return
        }
        
        let county = County.allCounties.filter({$0.name == countyName}).first
        setTitle(county?.name)
        flagImage.setImage(county?.flagImage)
        nameLabel.setText(county?.name)
        populationLabel.setText(county?.populationDescription)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
