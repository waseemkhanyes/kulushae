//
//  MotorMakeSingleModel.swift
//  Kulushae
//
//  Created by Waseem  on 13/11/2024.
//

import Foundation
import Combine

enum MotorMakeSingleModel {
    
    enum GetCarMakeRequest {
        
        struct Request: Codable {
            var page: Int
            var value: String?
        }
        
        struct Response: Codable {
            var arrayMotorMake: [MotorMake]
            var perPage: Int
            var currentPage: Int
            var total: Int
        }
    }
    
    enum GetCarModelRequest {
        struct Request: Codable {
            var makeId: Int
        }
        
        struct Response: Codable {
            var motorModels: [CarModels]
        }
    }
    
    class ViewModel: ObservableObject {
        var selectedCategory: CategoryListModel
        var motorMake: MotorMake
        
        private static let apiHandler = MotorMakesApiService()
        
        @Published var isLoading: Bool = false
        @Published var isShowEmptyMessage: Bool = false
        
        @Published var arrayMotorModels: [MotorModel] = []
        @Published var arrayFilteredMotorModels: [MotorModel] = []
        
        @Published var selectedModel: MotorModel? = nil
        
        @Published var searchText: String = ""
        
        @Published var isCarsSearchResultOpen: Bool = false
        
        @Published var isAll: Bool = false
        
        var arrayCancellables = Set<AnyCancellable>()
        
        var strLang: String {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        }
        
        init(category: CategoryListModel, motorMake: MotorMake) {
            selectedCategory = category
            self.motorMake = motorMake
            
            checkCacheMotorModel()
            
            defer {
                $searchText
                    .debounce(for: 0.3, scheduler: DispatchQueue.main)
                    .dropFirst() // This line drops the first value emitted after debounce
                    .sink(receiveValue: { [weak self] newText in
                        self?.searchMotorModels()
                    })
                    .store(in: &arrayCancellables)
            }
        }
        
        func searchMotorModels() {
            if self.searchText.isEmpty {
                self.arrayFilteredMotorModels = self.arrayMotorModels
            } else {
                self.arrayFilteredMotorModels = self.arrayMotorModels.filter({($0.title ?? "").hasPrefix(searchText)})
            }
        }
        
        func checkCacheMotorModel() {
            if let cachedData = UserDefaults.standard.data(forKey: "cacheMotorModel/\(motorMake.id)/\(strLang)"), let cachedMotorModel = try? JSONDecoder().decode([MotorModel].self, from: cachedData) {
                self.arrayMotorModels = cachedMotorModel
                self.arrayFilteredMotorModels = self.arrayMotorModels
            }
            
            getCarMotorModels(shouldLoading: arrayMotorModels.isEmpty, request: .init(makeId: Int(motorMake.id) ?? 0))
        }
        
        func onClickAll() {
            isAll = true
            selectedModel = nil
        }
        
        func onClickModel(_ model: MotorModel) {
            isAll = false
            selectedModel = model
        }
        
        func onClickApplyForAll() {
            guard selectedModel != nil || isAll else {
                return
            }
            
            isCarsSearchResultOpen = true
        }
        
        func getCarMotorModels(shouldLoading: Bool = false, request: MotorMakesListModel.GetCarModelRequest.Request) {
            if shouldLoading {
                self.isLoading = true
            }
            
            ViewModel.apiHandler.fetchCarModel(request: request) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isLoading = false
                }

                if let response = response {
                    self.arrayMotorModels = response.motorModels
                    self.arrayFilteredMotorModels = self.arrayMotorModels
                    
                    if let encodedData = try? JSONEncoder().encode(response) {
                        UserDefaults.standard.set(encodedData, forKey: "cacheMotorModel/\(request.makeId)/\(strLang)")
                    }
                }
            }
        }
    }
}

