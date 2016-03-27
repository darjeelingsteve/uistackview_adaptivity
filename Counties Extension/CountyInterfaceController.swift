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
    private var county: County?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        guard let countyName = context as? String else {
            return
        }
        
        self.county = County.countyForName(countyName)
        setTitle(county?.name)
        flagImage.setImage(county?.flagImage)
        nameLabel.setText(county?.name)
        populationLabel.setText(county?.populationDescription)
    }

    override func willActivate() {
        guard let county = county else {
            return
        }
        updateUserActivity(HandoffActivity.CountyDetails, userInfo: [HandoffUserInfo.CountyName: county.name], webpageURL: nil)
        
        super.willActivate()
    }

    override func didDeactivate() {
        invalidateUserActivity()
        super.didDeactivate()
    }
}
