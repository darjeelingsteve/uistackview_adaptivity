//
//  SpotlightSearchController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 08/11/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation
import CoreSpotlight
import CountiesModel

/// The class responsible for managing searches of the spotlight database.
class SpotlightSearchController {
    
    /// Represents an individual query request that can be made to
    /// `SpotlightSearchController`.
    struct Query {
        
        /// The different filter options available when querying the spotlight
        /// search results.
        ///
        /// * `allCounties` - Returns results from all of the counties.
        /// * `favouritesOnly` - Returns only counties that the user has
        /// favourited.
        enum Filter {
            case allCounties
            case favouritesOnly
        }
        
        /// The text that the user is searching for.
        let queryString: String
        
        /// The filter to apply to counties that match for `queryString`.
        let filter: Filter
    }
    
    private var query: CSSearchQuery? {
        didSet {
            // We have a new search query, so remove all old search results.
            searchResults.removeAll()
        }
    }
    
    /// The results returned by the most recent search.
    private(set) var searchResults = [County]()
    
    /// Performs a search on the Spotlight database with the given query string.
    ///
    /// - Parameters:
    ///   - searchQuery: The query to search for.
    ///   - completionHandler: The handler to call when the search is completed.
    func search(withQuery searchQuery: Query, completionHandler: @escaping () -> Void) {
        query?.cancel()
        query = CSSearchQuery(queryString: spotlightQueryString(fromQueryString: searchQuery.queryString), attributes: [])
        let countiesMatchingFilter = counties(matchingFilter: searchQuery.filter)
        query?.foundItemsHandler = { [unowned self] (items) in
            let matchingCounties = items.compactMap({ County.countyForName($0.uniqueIdentifier) }).filter({ countiesMatchingFilter.contains($0) })
            self.searchResults.append(contentsOf: matchingCounties)
        }
        query?.completionHandler = { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "nil")")
                return
            }
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        query?.start()
    }
    
    private func spotlightQueryString(fromQueryString queryString: String) -> String {
        let escapedString = queryString.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
        return "**=\"" + escapedString + "*\"cwdt"
    }
    
    private func counties(matchingFilter filter: Query.Filter) -> [County] {
        switch filter {
        case .allCounties:
            return County.allCounties
        case .favouritesOnly:
            return FavouritesController.shared.favouriteCounties
        }
    }
}
