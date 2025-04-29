//
//  CarListViewModel.swift
//  Kulushae
//
//  Created by Waseem  on 27/11/2024.
//

import Foundation
import Combine

class CarListViewModel {
    
    // MARK: Use cases
    
    enum GetCarRequest {
        struct Request: Codable {
            var page: Int?
            var userId: Int?
            var isPagination = false
            var catId: Int?
            var filterArray: [String: String?]?
        }
        struct Response: Codable {
            var carObject: [PostedCars]
            var total: Int
            var per_page: Int
        }
    }
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = HomeWebService()
        private var pusherManager = PusherManager.shared
        
        @Published var selectedCatId: String
        @Published var isCarLoading: Bool = false
        @Published var carObject: [PostedCars] = []
        @Published var totaladCount: Int = 0
        @Published var pageNumber: Int = 1
        @Published var user_id: Int?
        @Published var searchKey: String = ""

        @Published var scrollOffset = CGFloat.zero
        
        @Published var argsDictionary: [String: String?] = [:]
        @Published var isOpenFilterView: Bool = false
        @Published var isCarDetailView: Bool = false
        @Published var isPresentFilterSheet: Bool = false
//        @Published var isDetailViewActive = false
        
        var arrayCancellables = Set<AnyCancellable>()
        
        var selectedCar: PostedCars? = nil
        var detailCarId: Int {
            selectedCar?.id ?? 0
        }
        
        var currentPage: Int = 1
        var totalPageCount: Int = 1
        
        var strLang: String {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        }
        var isNew = false
        var cacheKey: String {
            isNew ? "cacheNewPostedMotors/\(self.selectedCatId)/\(strLang)" : "cachePostedMotors/\(self.selectedCatId)/\(strLang)"
        }
        
        var arrayFilters: [JSON] = []
        
        init(categoryId: String, search: String = "", userId: Int?, argsDictionary: [String: String?] = [:], isNew: Bool = false, arrayFilters: [JSON] = []) {
            self.selectedCatId = categoryId
            self.searchKey = search
            self.user_id = userId
            self.isNew = isNew
            print("** wk args1: \(argsDictionary)")
            self.argsDictionary = argsDictionary
            print("** wk args2: \(self.argsDictionary)")
            self.arrayFilters = arrayFilters
            
            checkCacheCarList()
            
            
            defer {
//                $searchKey
//                    .debounce(for: 0.3, scheduler: DispatchQueue.main)
//                    .dropFirst() // This line drops the first value emitted after debounce
//                    .sink(receiveValue: { [weak self] newText in
//                        self?.argsDictionary["keyword"] = newText
//                        self?.carObject = []
//                        self?.checkCacheCarList()
//                    })
//                    .store(in: &arrayCancellables)
                
                $isOpenFilterView
                    .dropFirst() // This line drops the first value emitted after debounce
                    .sink(receiveValue: { [weak self] newIsOpenFilterView in
                        if !newIsOpenFilterView {
                            self?.carObject = []
                            self?.checkCacheCarList()
                        }
                    })
                    .store(in: &arrayCancellables)
            }
        }
        
        func checkCacheCarList() {
//            if let cachedData = UserDefaults.standard.data(forKey: cacheKey), let cachedCars = try? JSONDecoder().decode([PostedCars].self, from: cachedData) {
//                
//                self.carObject = cachedCars
//            }
            print("** wk args3: \(self.argsDictionary)")
                  
            if let selectedCountry = PersistenceManager.shared.countryDataForSearch {
                argsDictionary["country_id"] = "\(selectedCountry.country.id)"
                if selectedCountry.selectedStateID > 0 {
                    argsDictionary["state_id"] = "\(selectedCountry.selectedStateID)"
                }
            }
            
            if isNew {
                argsDictionary["is_new"] = "1"
            }
            
            getPostedMotorList(
                shouldLoading: carObject.isEmpty,
                request: CarListViewModel.GetCarRequest.Request(
                    page: pageNumber,
                    userId: self.user_id,
                    isPagination: true,
                    catId: Int(selectedCatId),
                    filterArray: applyFilterOptions()
                )
            )
        }
        
        func configData(_ carResponse: CarListViewModel.GetCarRequest.Response) {
            totalPageCount = Int(round(Double(carResponse.total / carResponse.per_page)))
            self.carObject =   self.carObject + carResponse.carObject
//            totaladCount = carResponse.total
        }
        
        func onClickCar(_ item: PostedCars) {
            selectedCar = item
            isCarDetailView = true
        }
        
        func loadMoreData() {
            argsDictionary["keyword"] = searchKey
            if let selectedCountry = PersistenceManager.shared.countryDataForSearch {
                argsDictionary["country_id"] = "\(selectedCountry.country.id)"
                if selectedCountry.selectedStateID > 0 {
                    argsDictionary["state_id"] = "\(selectedCountry.selectedStateID)"
                }
            }
            
            let page = currentPage + 1
            if page <= totalPageCount {
                currentPage = page
                
                getPostedMotorList(
                    shouldLoading: carObject.isEmpty,
                    request: CarListViewModel.GetCarRequest.Request(
                        page: page,
                        userId: self.user_id,
                        isPagination: true,
                        catId: Int(selectedCatId),
                        filterArray: applyFilterOptions()
                    )
                )
            }
        }
        
        
        func getPostedMotorList(shouldLoading: Bool = false, request: CarListViewModel.GetCarRequest.Request) {
            if shouldLoading {
                self.isCarLoading = true
            }
            
            ViewModel.apiHandler.fetchAddedCarList(page: request.page, userId: request.userId, filterArray: request.filterArray, catId: request.catId) {
                [weak self] response,
                error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isCarLoading = false
                }
                
                if let carResponse = response {
                    if request.page ?? 0 == 1 {
                        if let encodedData = try? JSONEncoder().encode(carResponse.carObject) {
                            UserDefaults.standard.set(encodedData, forKey: cacheKey)
                        }
                    }
                    
                    self.configData(
                        CarListViewModel.GetCarRequest.Response(
                            carObject: carResponse.carObject,
                            total: carResponse.total,
                            per_page: carResponse.per_page
                        )
                    )
                }
                
                if(!error.debugDescription.isEmpty) {
                    print("errror", error.debugDescription)
                    
//                    errorMessage = error.debugDescription
                }
                
            }
        }
        
        func applyFilterOptions() -> [String: String?] {
            var data = self.argsDictionary
            if !arrayFilters.isEmpty {
    //                var data: [String: String] = [:]
                arrayFilters.forEach({ item in
                    print("** wk selection: \(item)")
                    if item["selection"].count > 0 {
                        let type = FilterOptonType(rawValue: item["type"].stringValue)
                        let key = item["field_name"].stringValue
                        if let type = type {
                            switch type {
                            case .DropDown:
                                if !item["selection"]["id"].stringValue.isEmpty {
                                    data[key] = item["selection"]["id"].stringValue
                                }
                            case .Slider:
                                if item["multiple"].boolValue {
                                    data[key] = item["selection"].arrayValue.map({$0["value"].stringValue}).joined(separator: ",")
                                } else {
                                    data[key] = item["selection"]["value"].stringValue
                                }
                            case .CheckBox:
                                data[key] = item["selection"].stringValue
                            case .Range:
                                if !item["selection"]["min"].stringValue.isEmpty {
                                    data["start_\(key)"] = item["selection"]["min"].stringValue
                                }
                                
                                if !item["selection"]["max"].stringValue.isEmpty {
                                    data["end_\(key)"] = item["selection"]["max"].stringValue
                                }
                            }
                        }
                    }
                })
            }
            
            return data
        }
    }
}

