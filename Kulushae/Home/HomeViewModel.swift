//
//  HomeViewModel.swift
//  Kulushae
//
//  Created by ios on 17/10/2023.
//

import Foundation
import Apollo

enum HomeViewModel {
    
    // MARK: Use cases
    
    enum MakeCategoryRequest {
        
        struct Request: Codable {
            var catId: Int?
            var showOnScreen: Int?
            var afl: Int?
        }
        
        struct Response: Codable {
            var categoryObject: [CategoryListModel]
        }
    }
    
    enum GetAdvRequest {
        struct Request: Codable {
            var page: Int?
            var userId: Int?
            var isPagination = false
            var catId: Int?
            var filterArray: [String: String?]?
        }
        
        struct Response: Codable {
            var advObject: [PropertyData]
            var total: Int
            var per_page: Int
        }
    }
    
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
        @Published var categoryObject: [CategoryListModel] = []
        @Published var availableForAddPost: [CategoryListModel] = []
        @Published var isLoading: Bool = false
        @Published var isCarLoading: Bool = false
        @Published var advObject: [PropertyData] = []
        @Published var carObject: [PostedCars] = []
        @Published var totalPageCount: Int = 1
        @Published var totaladCount: Int = 0
        @Published var categoryObjectList: [CategoryListModel] = []
        @Published var subCategoryObject: [CategoryListModel] = []
        @Published var countryList: [KulushaeCountry] = []
        @Published var bannerList: [BannerModel] = []
        @Published var errorMessage: String = ""
        @Published var selectedCountry: String = ""
        @Published var selectedCategory: String = ""
        
        func getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request, isFrom: String = "", _ handler: (()->())? = nil) {
            //            self.isLoading = true
            self.categoryObject = []
            ViewModel.apiHandler.fetchCategoryList(afl: request.afl, catId: request.catId, showOnScreen: request.showOnScreen) { [weak self] response, error in
                guard let self = self else { return }
                //                self.isLoading = false
                if let categoryResponse = response {
                    availableForAddPost = categoryResponse.filter { $0.active_for_listing == true }
                    self.categoryObject = categoryResponse
                    
                    if categoryResponse.count > 0 {
                        self.cacheCategoryData(categoryResponse)
                        UserDefaults.standard.set(Date(), forKey: lastFetchTimeKey)
                    }
                    
                    if(isFrom == "main category") {
                        self.categoryObjectList = categoryResponse
                    }
                    if(isFrom == "sub category") {
                        self.subCategoryObject = categoryResponse
                    }
                    
                    handler?()
                }
            }
        }
        
        private func cacheCategoryData(_ data: [CategoryListModel]) {
            if let encodedData = try? JSONEncoder().encode(data) {
                UserDefaults.standard.set(encodedData, forKey: categoryCacheKey)
            }
        }
        
        func getSubCategoryList(request: HomeViewModel.MakeCategoryRequest.Request, isFrom: String = "") {
            //            self.isLoading = true
            //self.categoryObject = []
            ViewModel.apiHandler.fetchSubCategoryList(afl: request.afl, catId: request.catId,showOnScreen: request.showOnScreen) { [weak self] response, error in
                guard let self = self else { return }
                //                self.isLoading = false
                if let categoryResponse = response {
                   // availableForAddPost = categoryResponse.filter { $0.active_for_listing == true }
                    self.subCategoryObject = categoryResponse
//                    if(isFrom == "main category") {
//                        self.categoryObjectList = categoryResponse
//                    }
//                    if(isFrom == "sub category") {
//                        self.subCategoryObject = categoryResponse
//                    }
                }
            }
        }
        
        
        func getPostedAdvList(request: HomeViewModel.GetAdvRequest.Request) {
            self.isLoading = true
            if(!request.isPagination)  {
                self.advObject = []
            }
            ViewModel.apiHandler.fetchAddedAdvList(page: request.page, userId: request.userId, filterArray: request.filterArray, catId: request.catId) { [weak self] response, error in
                guard let self = self else { return }
                
                if let advResponse = response {
                    totalPageCount = max(1, Int(ceil(Double(advResponse.total) / Double(advResponse.per_page))))
                    self.advObject =   self.advObject + advResponse.advObject
                    totaladCount = advResponse.total
                    self.isLoading = false
                } else {
                    self.isLoading = false
                }
                
                if(!error.debugDescription.isEmpty) {
                    print("errror", error.debugDescription)
                    
                    errorMessage = error.debugDescription
                    
                }
                
            }
        }
        
        func getPostedMotorList(request: HomeViewModel.GetCarRequest.Request) {
            self.isCarLoading = true
            if(!request.isPagination)  {
                self.carObject = []
            }
            ViewModel.apiHandler.fetchAddedCarList(page: request.page, userId: request.userId, filterArray: request.filterArray, catId: request.catId) { [weak self] response, error in
                guard let self = self else { return }
                
                if let carResponse = response {
                    totalPageCount = Int(round(Double(carResponse.total / carResponse.per_page)))
                    self.carObject =   self.carObject + carResponse.carObject
                    totaladCount = carResponse.total
                    self.isCarLoading = false
                }
                else {
                    self.isCarLoading = false
                }
                if(!error.debugDescription.isEmpty) {
                    print("errror", error.debugDescription)
                    
                    errorMessage = error.debugDescription
                }
                
            }
        }
        
        func getCountryList(){
            ViewModel.apiHandler.fetchCountriesList() { [weak self] response, error in
                self?.countryList = response
                if let cityId: Int = UserDefaultManager.get(.choseCityId) {
                    self?.selectedCountry = response.first(where: { $0.id == cityId })?.name ?? ""
                }
            }
        }
        
        func getBannersList(serviceID:String){
            ViewModel.apiHandler.fetchBannersList(serviceID: serviceID) { [weak self] response, error in
                self?.bannerList = response
            }
        }
    }
}
