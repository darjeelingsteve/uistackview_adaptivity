//
//  AdaptivityApp.swift
//  Counties (watchOS) WatchKit Extension
//
//  Created by Stephen Anthony on 03/10/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import SwiftUI
import CountiesModel

@main
struct AdaptivityApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RegionsListView(regions: Country.unitedKingdom.regions)
            }
        }
    }
}
