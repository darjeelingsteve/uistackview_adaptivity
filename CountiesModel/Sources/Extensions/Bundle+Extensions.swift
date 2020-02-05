//
//  Bundle+Extensions.swift
//  CountiesModel
//
//  Created by Stephen Anthony on 05/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// The `Bundle` of the `CountiesModel` framework.
    static var countiesModelBundle: Bundle {
        #if os(iOS)
        return Bundle(identifier: "com.darjeeling.CountiesModel-iOS")!
        #elseif os(watchOS)
        return Bundle(identifier: "com.darjeeling.CountiesModel-watchOS")!
        #endif
    }
}
