//
//  MotorFilterViewModel.swift
//  Kulushae
//
//  Created by ios on 12/05/2024.
//

import Foundation
import CoreLocation

enum MotorFilterViewModel {
    
    enum GetCarMakeRequest {
        
        struct Request: Codable {
        }
        
        struct Response: Codable {
            var motorMakeObject: CarMakeModel
        }
    }
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = MotorFilterWebServices()
        
        @Published var isLoading: Bool = false
        @Published var motorMakeList: [MotorMake] = []
        @Published var motorMakeListName: [String] = []
        @Published var motorModelList: [MotorModel] = []
        @Published var motorModelListName: [String] = []
        @Published var statesList: StatesModel = []
        @Published var statesNameList: [String] = []
        @Published var selectedLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        func getMotorMake() {
            self.isLoading = true
            ViewModel.apiHandler.fetchCarMake() { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                self.motorMakeList =   response
                motorMakeListName = response.map { $0.title}
            }
        }
        
        func getMotorModel(makeId: String ) {
            self.isLoading = true
            ViewModel.apiHandler.fetchCarModel(id: makeId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                self.motorModelList = response
                motorModelListName = response.map { $0.title ?? ""}
            }
        }
        
        func getStates() {
            ViewModel.apiHandler.fetchStateList() { [weak self] response, error in
                guard let self = self else { return }
                self.statesList =   response
                statesNameList = response.map { $0.name ?? $0.state_code ?? ""}
                if let coordinates = self.getFirstItemCoordinates() {
                    selectedLocation = coordinates
                } else {
                    print("No valid coordinates found for the first item.")
                }
            }
        }
        func getFirstItemCoordinates() -> CLLocationCoordinate2D? {
            guard let firstItem = statesList.last,
                  let latitude = firstItem.latitude,
                  let longitude = firstItem.longitude else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
