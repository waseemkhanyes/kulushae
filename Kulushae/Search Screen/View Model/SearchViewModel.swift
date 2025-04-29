//
//  SearchViewModel.swift
//  Kulushae
//
//  Created by ios on 26/02/2024.
//

import Foundation
import Apollo

enum SearchViewModel {
    
    enum GetProductDetailsRequest {
        struct Request: Codable {
            var value: String
            var serviceType: String
        }
        struct Response: Codable {
            var searchList: [SearchModel]
        }
    }
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = SearchWebService()
        
        @Published var isLoading: Bool = false
        @Published var searchObjectList: [SearchModel] = []
        
        func getSearResults(request: SearchViewModel.GetProductDetailsRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.fetchSearchItems(searchKey: request.value, serviceType: request.serviceType) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let searchResponse = response {
                    self.searchObjectList =   searchResponse
                }
            }
        }
    }
}
