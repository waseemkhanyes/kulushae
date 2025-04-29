//
//  PropertyListScreenViewModel.swift
//  Kulushae
//
//  Created by Waseem  on 30/11/2024.
//

import Foundation

enum PropertyListScreenViewModel {
    
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
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = HomeWebService()
        private var pusherManager = PusherManager.shared
        
        @Published var arraySubCategory: [CategoryListModel] = []
        
        @Published var isLoading: Bool = false
        @Published var advObject: [PropertyData] = []
        @Published var totaladCount: Int = 0
        
        @Published var isDetailViewActive = false
        
        @Published var errorMessage: String = ""
        
        @Published var searchKey: String = ""
        @Published var searchLocationArray: [String] = []
        
        @Published var isOpenFilterView: Bool = false
        @Published var isOpenLocSearchView: Bool = false
        @Published var argsDictionary: [String: String?] = [:]
        
        @Published var scrollOffset = CGFloat.zero
        
        var selectedCategory: CategoryListModel?
        var selectedSubCategory: CategoryListModel? = nil
        
        var selectedProperty: PropertyData?
        
        var selectedCatId: Int {
            Int(selectedCategory?.id ?? "0") ?? 0
        }
        
        var user_id: Int?
        
        var currentPage: Int = 1
        var totalPageCount: Int = 1
        
        var strLang: String {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        }
        
        init(category: CategoryListModel? = nil, userId: Int? = nil) {
            self.selectedCategory = category
            
            self.user_id = userId
            
            checkCachePropertiesAdv()
            
            checkCacheSubCategory(catId: selectedCatId)
        }
        
        func checkCachePropertiesAdv() {
            var catgId = selectedCatId
            if let selectedSubCategory {
                catgId = Int(selectedSubCategory.id) ?? 0
            }
            
            advObject = []
            currentPage = 1
            totaladCount = 0
            
            if let cachedData = UserDefaults.standard.data(forKey: "cachePropertiesAdv/\(catgId)/\(strLang)"), let cachedAdv = try? JSONDecoder().decode([PropertyData].self, from: cachedData) {
                self.advObject = cachedAdv
            }
            
            if let selectedCountry = PersistenceManager.shared.countryDataForSearch {
                argsDictionary["country_id"] = "\(selectedCountry.country.id)"
                if selectedCountry.selectedStateID > 0 {
                    argsDictionary["state_id"] = "\(selectedCountry.selectedStateID)"
                }
            }
            
            getPostedAdvList(shouldLoading: advObject.isEmpty, request: PropertyListScreenViewModel.GetAdvRequest.Request(page: currentPage,catId: catgId))
        }
        
        func checkCacheSubCategory(catId: Int) {
            if let cachedData = UserDefaults.standard.data(forKey: "cacheSubcategory/\(catId)/\(strLang)"), let cachedSubCtg = try? JSONDecoder().decode([CategoryListModel].self, from: cachedData) {
                self.configSubCategory(cachedSubCtg)
            }
            
            getSubCategoryList(request: HomeViewNewModel.MakeCategoryRequest.Request(catId: catId))
        }
        
        func configSubCategory(_ data: [CategoryListModel]) {
            arraySubCategory = data
        }
        
        func onClickProperty(_ property: PropertyData) {
            selectedProperty = property
            isDetailViewActive = true
        }
        
        func loadMoreData() {
            let page = currentPage + 1
            
            let catId = selectedSubCategory == nil ? selectedCatId : Int(selectedSubCategory?.id ?? "0") ?? 0
            //        guard !dataHandler.isLoading else { return }
            argsDictionary["keyword"] = searchKey
            if let selectedCountry = PersistenceManager.shared.countryDataForSearch {
                argsDictionary["country_id"] = "\(selectedCountry.country.id)"
                if selectedCountry.selectedStateID > 0 {
                    argsDictionary["state_id"] = "\(selectedCountry.selectedStateID)"
                }
            }
            
            if !searchLocationArray.isEmpty {
                argsDictionary["location"] = searchLocationArray.joined(separator: ",")
            }
            
            if page <= totalPageCount {
                currentPage = page
                
                self.getPostedAdvList(shouldLoading: true,
                    request: PropertyListScreenViewModel.GetAdvRequest.Request(
                        page: self.currentPage,
                        userId: self.user_id,
                        isPagination: true,
                        catId: catId,
                        filterArray: self.argsDictionary
                    )
                )
            }
        }
        
        func getPostedAdvList(shouldLoading: Bool = false, request: PropertyListScreenViewModel.GetAdvRequest.Request) {
            if shouldLoading {
                self.isLoading = true
            }
            
            ViewModel.apiHandler.fetchAddedAdvList(page: request.page, userId: request.userId, filterArray: request.filterArray, catId: request.catId) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isLoading = false
                }
                
                if let advResponse = response {
                    totalPageCount = max(1, Int(ceil(Double(advResponse.total) / Double(advResponse.per_page))))
                    self.advObject =   self.advObject + advResponse.advObject
                    
                    if request.page ?? 0 == 1 {
                        if let encodedData = try? JSONEncoder().encode(advResponse.advObject) {
                            UserDefaults.standard.set(encodedData, forKey: "cachePropertiesAdv/\(request.catId ?? 0)/\(strLang)")
                        }
                        
                        totaladCount = advResponse.total
                    }
                }
                
                if(!error.debugDescription.isEmpty) {
                    print("errror", error.debugDescription)
                    
//                    errorMessage = error.debugDescription
                    
                }
                
            }
        }
        
        func getSubCategoryList(shouldLoading: Bool = false, request: HomeViewNewModel.MakeCategoryRequest.Request) {
            if shouldLoading {
                self.isLoading = true
            }
            ViewModel.apiHandler.fetchSubCategoryList(afl: request.afl, catId: request.catId,showOnScreen: request.showOnScreen) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isLoading = false
                }
                
                if let categoryResponse = response {
                    self.arraySubCategory = categoryResponse
                    
                    if let encodedData = try? JSONEncoder().encode(self.arraySubCategory) {
                        UserDefaults.standard.set(encodedData, forKey: "cacheSubcategory/\(request.catId ?? 0)/\(strLang)")
                    }
                }
            }
        }
    }
}
