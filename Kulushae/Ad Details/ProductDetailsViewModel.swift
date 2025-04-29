//
//  ProductDetailsViewModel.swift
//  Kulushae
//
//  Created by ios on 29/11/2023.
//

import Foundation
import Apollo

enum ProductDetailsViewModel {
    
    // MARK: Use cases
    
    enum GetProductDetailsRequest {
        
        struct Request: Codable {
            var propertyId: Int
        }
        
        struct Response: Codable {
            var advObject: PropertyData
        }
    }
    
    enum AddFavourite {
        
        struct Request: Codable {
            let like: Bool
            let itemId: Int
            let type: String
        }
        
        struct Response: Codable {
            var isFaveAdded: Bool
        }
    }
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = ProductDetailsWebService()
        
        @Published var isLoading: Bool = false
        @Published var advObject: PropertyData = PropertyData(id: -1, title: "", contactNumber: nil, description_val: nil, socialmedia: nil, size: nil, bedrooms: nil, bathrooms: nil, amenities: nil, userID: nil, neighbourhood: nil, location: nil,  categoryID: nil,images: nil, price: nil, isFeatured: nil, type: nil, youtube_url: nil, three_sixty_url: nil, country: nil, emirates: nil, deposit: nil, referenceNumber: nil, developer: nil, readyBy: nil, anualCommunityFee: nil, furnished: nil, totalClosingFee: nil, buyerTransferFee: nil, sellerTransferFee: nil, maintenanceFee: nil, occupancyStatus: nil, postedBy: nil)
        @Published var scrollOffset = CGFloat.zero
        
        func getAdvDetails(request: ProductDetailsViewModel.GetProductDetailsRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.fetchAdDetails(productId: request.propertyId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let advResponse = response {
                    self.advObject =   advResponse.advObject
                }
            }
        }
        
        func addFavDetails(request: ProductDetailsViewModel.AddFavourite.Request) {
//            self.isLoading = true
            ViewModel.apiHandler.insertToFavourite(productId: request.itemId, isLike: request.like, type: request.type) { [weak self] response, error in
                guard let self = self else { return }
//                self.isLoading = false
            }
        }
    }
}
