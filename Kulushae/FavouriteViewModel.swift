//
//  FavouriteViewModel.swift
//  Kulushae
//
//  Created by ios on 28/02/2024.
//

import Foundation
import Apollo

enum FavouriteViewModel {
    
    enum GetFavRequest {
        struct Request: Codable {
            var page: Int?
            var userId: Int
        }
        
        struct Response: Codable {
            var favObject: [FavouriteModel]
            var total: Int
            var per_page: Int
        }
    }
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = FavouriteWebService()
        @Published var advObject: [FavouriteModel] = []
        @Published var totalPageCount: Int = 1
        @Published var errorMessage: String = ""
        @Published var isLoading: Bool = false
        
        func fetchFavAdvList(request: FavouriteViewModel.GetFavRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.fetchFavAdvList(page: request.page, userId: request.userId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let advResponse = response {
                    totalPageCount = max(1, Int(ceil(Double(advResponse.total) / Double(advResponse.per_page))))
                    
                   
                    print("ttal fil", totalPageCount)
                    self.advObject =   self.advObject + advResponse.favObject
                }
                if(!error.debugDescription.isEmpty) {
                    print("errror", error.debugDescription)
                    errorMessage = error.debugDescription
                }
                
            }
        }
    }
}
