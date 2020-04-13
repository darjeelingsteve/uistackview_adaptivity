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
    private var tableSections: [CountiesTableSection]?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        tableSections = Country.unitedKingdom.regions.map({ (region) in
            let tableSection = CountiesTableSection(region: region, rowsAlreadyRegisteredCount: table.numberOfRows)
            tableSection.registerRows(in: table)
            return tableSection
        })
        
        (0..<table.numberOfRows).forEach { (tableRowIndex) in
            let rowController = table.rowController(at: tableRowIndex)
            let tableSection = tableSections?.section(forTableRowIndex: tableRowIndex)
            if let regionNameRowController = rowController as? RegionNameRowController {
                regionNameRowController.region = tableSection?.region
            } else if let countyRowController = rowController as? CountyRowController {
                countyRowController.county = tableSection?.county(forTableRowIndex: tableRowIndex)
            }
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        let tableSection = tableSections?.section(forTableRowIndex: rowIndex)
        return tableSection?.county(forTableRowIndex: rowIndex).name
    }
}
