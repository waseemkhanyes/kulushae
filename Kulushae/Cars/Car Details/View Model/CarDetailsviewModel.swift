//
//  CarDetailsviewModel.swift
//  Kulushae
//
//  Created by ios on 01/04/2024.
//

import Foundation


enum CarDetailsViewModel {
    
    enum GetCarDetailsRequest {
        struct Request: Codable {
            
            var carId: Int
        }
        
        struct Response: Codable {
            var motorObject: PostedCars
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
        
        private static let apiHandler = CarDetailsWebService()
        
        @Published var isLoading: Bool = false
        @Published var motorObject: PostedCars = PostedCars(id: nil, emirates: nil, make: nil, model:nil, trim: nil, specs: nil, year: nil, kilometers: nil, insuredInUae: nil, price: nil, contactInfo: nil, title: nil, desc: nil, tourURL: nil, fuelType: nil, exteriorColor: nil, interiorColor: nil, warranty: nil, doors: nil, noOfCylinders: nil, transmissionType: nil, bodyType: nil, seatingCapacity: nil, horsepwer: nil, engineCapacity: nil, steeringSide: nil, seller: nil, extras: nil, images: nil, categoryID: 0, makeId: nil, modelId: nil, isNew: nil)
        @Published var scrollOffset = CGFloat.zero
        
        func getMotorDetails(request: CarDetailsViewModel.GetCarDetailsRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.fetchCarDetails(carId: request.carId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let motorResponse = response {
                    self.motorObject =   motorResponse.motorObject
                }
            }
        }
        
        func addFavDetails(request: CarDetailsViewModel.AddFavourite.Request) {
//            self.isLoading = true
            ViewModel.apiHandler.insertToFavourite(CarId: request.itemId, isLike: request.like, type: request.type) { [weak self] response, error in
                guard let self = self else { return }
//                self.isLoading = false
            }
        }
    }
}
