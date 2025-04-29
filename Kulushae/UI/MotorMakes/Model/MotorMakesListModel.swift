//
//  MotorMakesListModel.swift
//  Kulushae
//
//  Created by Waseem  on 12/11/2024.
//


import Foundation
import Combine

enum MotorMakesListModel {
    
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
            var motorModels: [MotorModel]
        }
    }
    
    class ViewModel: ObservableObject {
        var selectedCategory: CategoryListModel
        
        private static let apiHandler = MotorMakesApiService()
        
        @Published var isLoading: Bool = false
        @Published var isShowEmptyMessage: Bool = false
        
        @Published var scrollOffset = CGFloat.zero
        
        @Published var arrayMotorMakes: [MotorMake] = []
        @Published var searchText: String = ""
        
        @Published var isPresentMotorMakeSingleView: Bool = false
        
        var selectedMotor: MotorMake? = nil
        
        var arrayCancellables = Set<AnyCancellable>()
        
        var currentPage: Int = 1
        var totalPageCount: Int = 1
        
        var strLang: String {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        }
        
        init(category: CategoryListModel) {
            self.selectedCategory = category
            
            checkCacheMotorMake()
            
            defer {
                $searchText
                    .debounce(for: 0.3, scheduler: DispatchQueue.main)
                    .dropFirst() // This line drops the first value emitted after debounce
                    .sink(receiveValue: { [weak self] newText in
                        self?.loadMoreData(page: 1)
                    })
                    .store(in: &arrayCancellables)
            }
        }
        
        func checkCacheMotorMake() {
            if let cachedData = UserDefaults.standard.data(forKey: "cacheMotorMake/\(strLang)"), let cachedMotorMake = try? JSONDecoder().decode([MotorMake].self, from: cachedData) {
                self.configMotorMakes(.init(arrayMotorMake: cachedMotorMake, perPage: 20, currentPage: 1, total: 30))
            }
            
            getCarMotorMakesList(shouldLoading: arrayMotorMakes.isEmpty, request: .init(page: 1, value: searchText))
        }
        
        func loadMoreData(page: Int) {
            if page <= totalPageCount {
                getCarMotorMakesList(shouldLoading: true, request: .init(page: page, value: searchText))
            }
        }
        
        func configMotorMakes(_ response: MotorMakesListModel.GetCarMakeRequest.Response) {
            currentPage = response.currentPage
            totalPageCount = max(1, Int(ceil(Double(response.total) / Double(response.perPage))))
            
            if currentPage == 1 {
                arrayMotorMakes = response.arrayMotorMake
            } else {
                arrayMotorMakes += response.arrayMotorMake
            }
        }
        
        func onClickItemActions(isLoadMore: Bool, item: MotorMake) {
            if isLoadMore {
                loadMoreData(page: currentPage + 1)
            } else {
                selectedMotor = item
                isPresentMotorMakeSingleView = true
            }
        }
        
        func getCarMotorMakesList(shouldLoading: Bool = false, request: MotorMakesListModel.GetCarMakeRequest.Request) {
            if shouldLoading {
                self.isLoading = true
            }
            
            ViewModel.apiHandler.fetchCarMake(request: request) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isLoading = false
                }

                if let response = response {
                    self.configMotorMakes(response)
                    if request.page == 1 && (request.value ?? "").isEmpty {
                        if let encodedData = try? JSONEncoder().encode(response) {
                            UserDefaults.standard.set(encodedData, forKey: "cacheMotorMake/\(strLang)")
                        }
                    }
                }
            }
        }
    }
}
