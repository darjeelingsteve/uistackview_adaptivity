//
//  InterfaceController.swift
//  Counties Extension
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet private weak var table: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        table.setNumberOfRows(County.allCounties.count, withRowType: String(CountyRowController))
        for (index, county) in County.allCounties.enumerate() {
            (table.rowControllerAtIndex(index) as! CountyRowController).county = county
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return County.allCounties[rowIndex].name
    }
}
