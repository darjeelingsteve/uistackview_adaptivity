//
//  SpotlightSearchController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 08/11/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import Foundation
import CoreSpotlight

/// The class responsible for managing searches of the spotlight database.
class SpotlightSearchController {
    private var query: CSSearchQuery? {
        didSet {
            // We have a new search query, so remove all old search results.
            searchResults.removeAll()
        }
    }
    
    private(set) var searchResults = [County]()
    
    /// Performs a search on the Spotlight database with the given query string.
    ///
    /// - Parameters:
    ///   - queryString: The query string to search for.
    ///   - completionHandler: The handler to call when the search is completed.
    func search(withQueryString queryString: String, completionHandler: @escaping () -> Void) {
        query?.cancel()
        
        query = CSSearchQuery(queryString: spotlightQueryString(fromQueryString: queryString), attributes: [])
        
        query?.foundItemsHandler = { [unowned self] (items) in
            self.searchResults.append(contentsOf: items.flatMap { County.countyForName($0.uniqueIdentifier) })
        }
        
        query?.completionHandler = { [unowned self]  (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription)")
                return
            }
            self.searchResults.sort(by: { $0.name < $1.name })
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
}
