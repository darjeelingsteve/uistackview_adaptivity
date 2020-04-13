//
//  CountiesTableSection.swift
//  Counties Extension
//
//  Created by Stephen Anthony on 13/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import WatchKit
import Foundation
import CountiesModel

/// Represents a section in the counties table.
struct CountiesTableSection {
    
    /// The region represented by the receiver.
    let region: Region
    
    private let offset: Int
    fileprivate var tableRowIndexes: [Int] {
        return [offset] + (1...region.counties.count).map({ offset + $0 })
    }
    
    init(region: Region, rowsAlreadyRegisteredCount: Int) {
        self.region = region
        offset = rowsAlreadyRegisteredCount
    }
    
    /// Registers the recevier's required rows in the given table.
    /// - Parameter table: The table in which to register to rows.
    func registerRows(in table: WKInterfaceTable) {
        table.insertRows(at: IndexSet(integer: offset), withRowType: String(describing: RegionNameRowController.self))
        let indexes = (1...region.counties.count).map { index in offset + index }
        table.insertRows(at: IndexSet(indexes), withRowType: String(describing: CountyRowController.self))
    }
    
    /// Allows access to the county contained in the receiver's `region` by the
    /// index of the county in the counties table.
    /// - Parameter tableRowIndex: The table row index of the county we wish to
    /// access.
    /// - Returns: The county represented at the given table row index.
    func county(forTableRowIndex tableRowIndex: Int) -> County {
        return region.counties[tableRowIndex - offset - 1]
    }
}

extension Array where Element == CountiesTableSection {
    
    /// Allows access to the table section contained in the receiver that is
    /// responsible for the county represented at the given table row index.
    /// - Parameter tableRowIndex: The table row index of the county managed by
    /// the table section we wish to access.
    /// - Returns: The table section managing the county represented at the
    /// given table row index.
    func section(forTableRowIndex tableRowIndex: Int) -> CountiesTableSection? {
        return first(where: { $0.tableRowIndexes.contains(tableRowIndex) })
    }
}
