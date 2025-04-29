//
//  SearchLocationManager.swift
//  Kulushae
//
//  Created by ios on 14/02/2024.
//

import Foundation
import MapboxSearch

// Create a SearchDelegate class
class SearchDelegate: NSObject, ObservableObject, SearchEngineDelegate {
    @Published var searchResults: [CustomSearchResult] = []
    
    override init() {
        super.init()
        // Set the delegate for the SearchEngineSingleton.shared instance
        SearchEngineSingleton.shared.delegate = self
        
        
    }
    
    func searchAddress(query: String, filter: String? = nil) {
        //        print("Search Address called with query: \(query)")
        // Implement your search logic here using the provided query
        var options = SearchOptions(countries: ["AE", "BH", "EG", "IQ", "KW", "LB","OM","QA", "SA"])
        if let filter {
            options = SearchOptions(countries: [filter])
        }
        print("** wk search options: \(options)")
        SearchEngineSingleton.shared.search(query: query, options: options)
    }
    
    func suggestionsUpdated(suggestions: [MapboxSearch.SearchSuggestion], searchEngine: MapboxSearch.SearchEngine) {
        //        DispatchQueue.main.async {
        self.searchResults = []
        //        }
        for result in suggestions {
            let customResult = CustomSearchResult(id: result.id,
                                                  name: result.name,
                                                  serverIndex: result.serverIndex,
                                                  descriptionText: result.descriptionText,
                                                  categories: result.categories,
                                                  address: result.address,
                                                  iconName: result.iconName,
                                                  suggestionType: result.suggestionType,
                                                  searchRequest: result.searchRequest,
                                                  distance: result.distance,
                                                  batchResolveSupported: result.batchResolveSupported)
            // Update the searchResults array
            DispatchQueue.main.async {
                self.searchResults.append(customResult)
            }
        }
        
    }
    
    func searchErrorHappened(searchError: MapboxSearch.SearchError, searchEngine: MapboxSearch.SearchEngine) {
        
    }
    
    func resultResolved(result: MapboxSearch.SearchResult, searchEngine: MapboxSearch.SearchEngine) {
        print("Result resolved with name: \(result.name)")
        
    }
    
}
