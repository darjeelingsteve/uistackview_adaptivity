//
//  PlatformHelpers.swift
//  CountiesUI iOS
//
//  Created by Stephen Anthony on 06/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

func platformValue<T>(foriOS iOSValue: T, tvOS tvOSValue: T) -> T {
    #if os(tvOS)
    return tvOSValue
    #else
    return iOSValue
    #endif
}
