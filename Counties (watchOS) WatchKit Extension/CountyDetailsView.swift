//
//  CountyDetailsView.swift
//  Counties (watchOS) WatchKit Extension
//
//  Created by Stephen Anthony on 03/10/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import SwiftUI
import CountiesModel

/// The view for showing an individual counties' details.
struct CountyDetailsView: View {
    
    /// The county displayed by the receiver.
    var county: County
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: county.flagImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Text(county.name)
                    .font(.headline)
                Text(county.populationDescription)
                    .multilineTextAlignment(.center)
            }
        }.navigationTitle(county.name)
    }
}

struct CountyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountyDetailsView(county: Country.unitedKingdom.county(forName: "Hampshire")!)
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
            CountyDetailsView(county: Country.unitedKingdom.county(forName: "Surrey")!)
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 40mm"))
        }
    }
}
