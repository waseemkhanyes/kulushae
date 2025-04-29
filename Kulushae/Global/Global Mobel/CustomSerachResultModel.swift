//
//  CustomSerachResultModel.swift
//  Kulushae
//
//  Created by ios on 10/11/2023.
//

import MapboxSearch

struct CustomSearchResult: SearchSuggestion {
    var mapboxId: String?
    
    let id: String
    let name: String
    let serverIndex: Int?
    let descriptionText: String?
    let categories: [String]?
    let address: Address?
    let iconName: String?
    let suggestionType: SearchSuggestType
    let searchRequest: SearchRequestOptions
    let distance: CLLocationDistance?
    let batchResolveSupported: Bool
    
    // Additional properties specific to your use case
    // ...
    
    // Implement the required initializer
    init(id: String,
         name: String,
         serverIndex: Int?,
         descriptionText: String?,
         categories: [String]?,
         address: Address?,
         iconName: String?,
         suggestionType: SearchSuggestType,
         searchRequest: SearchRequestOptions,
         distance: CLLocationDistance?,
         batchResolveSupported: Bool) {
        self.id = id
        self.name = name
        self.serverIndex = serverIndex
        self.descriptionText = descriptionText
        self.categories = categories
        self.address = address
        self.iconName = iconName
        self.suggestionType = suggestionType
        self.searchRequest = searchRequest
        self.distance = distance
        self.batchResolveSupported = batchResolveSupported
        
        // Initialize additional properties
        // ...
    }
}
