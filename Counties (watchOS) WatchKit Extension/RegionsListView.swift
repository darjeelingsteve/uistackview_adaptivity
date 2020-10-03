//
//  RegionsListView.swift
//  Counties (watchOS) WatchKit Extension
//
//  Created by Stephen Anthony on 03/10/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import SwiftUI
import CountiesModel

/// The view responsible for showing a list of regions.
struct RegionsListView: View {
    
    /// The regions displayed by the receiver.
    var regions: [Region]
    
    var body: some View {
        List {
            ForEach(regions, id: \.self) { region in
                Section(header: Text(region.name)) {
                    ForEach(region.counties, id: \.self) { county in
                        NavigationLink(destination: CountyDetailsView(county: county)) {
                            Image(uiImage: county.flagImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32)
                            Text(county.name)
                                .scaledToFit()
                        }
                    }
                }
            }.navigationTitle("Counties")
        }
    }
}

struct RegionsListView_Previews: PreviewProvider {
    static var previews: some View {
        RegionsListView(regions: Country.unitedKingdom.regions)
    }
}
