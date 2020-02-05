//
//  InterfaceController.swift
//  Counties Extension
//
//  Created by Stephen Anthony on 02/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import WatchKit
import Foundation
import CountiesModel

class InterfaceController: WKInterfaceController {
    @IBOutlet fileprivate weak var table: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        table.setNumberOfRows(County.allCounties.count, withRowType: String(describing: CountyRowController.self))
        for (index, county) in County.allCounties.enumerated() {
            (table.rowController(at: index) as! CountyRowController).county = county
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return County.allCounties[rowIndex].name
    }
}
