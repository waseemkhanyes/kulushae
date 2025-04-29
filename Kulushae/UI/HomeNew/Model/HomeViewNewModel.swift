//
//  HomeViewNewModel.swift
//  Kulushae
//
//  Created by Waseem  on 09/11/2024.
//

import Foundation
import Apollo

enum HomeViewNewModel {
    
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
        
        @Published var arrayCategory: [CategoryListModel] = []
        @Published var arraySubCategory: [CategoryListModel] = []
        @Published var arrayMotorQuickLinks: [JSON] = []
        
        @Published var arrayMotorMakes: [MotorMake] = []
        
        @Published var isLoading: Bool = false
        
        @Published var selectedCategory: CategoryListModel? = nil
        @Published var selectedCategoryForPropertyList: CategoryListModel? = nil
        @Published var selectedQuickLinkItem: JSON? = nil
        
        @Published var isSearchScreenOpen = false
        @Published var scrollOffset = CGFloat(0.01)
        @Published var isHideCategoryImage: Bool = false
        
        @Published var arrayBanners: [BannerModel] = []
        
        @Published var arrayAdvObject: [PropertyData] = []
        @Published var arrayCarsObject: [PostedCars] = []
        @Published var arrayNewCarsObject: [PostedCars] = []
        
        @Published var selectedRecentId: Int = -1
        @Published var selectedProductType: String = ""
        @Published var isOpenCarDetails: Bool = false
        
        @Published var isSearchResultOpen: Bool = false
        @Published var isCarsSearchResultOpen: Bool = false
        @Published var isNewCarsSearchResultOpen: Bool = false
        @Published var isDetailViewActive: Bool = false
        @Published var isFavourite: Bool = false
        @Published var isFavClicked: Bool = false
        
        @Published var totalPageCount: Int = 1
        @Published var totaladCount: Int = 0
        @Published var errorMessage: String = ""
        
        @Published var isCarLoading: Bool = false
        
        @Published var isPresentAllMotorMakeBrands: Bool = false
        @Published var strSelectedLocation: String = ""
        
        var selectedMotorMakeBrandItem: MotorMake? = nil
        @Published var isPresentMotorMakeSingleView: Bool = false
        
        var selectedPostedCar: PostedCars? = nil
        @Published var isPresentCarDetail: Bool = false
        @Published var isPresentSelectLocation: Bool = false
        @Published var isSelectLanguageAfterInstall: Bool = false
        @Published var isPresentFilterSheet: Bool = false
        
        var strLang: String {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        }
        
        @Published var contentHeight: CGFloat = 0
        @Published var scrollEnabled: Bool = true
        
        var arrayFilters: [JSON] = []
        
        
        init(language: String) {
            checkCacheCategory()
            if let lang = UserDefaults.standard.string(forKey: "AppLanguage") {
                loadCacheOFSelectedLocationFromUserDefaults()
            } else {
                isSelectLanguageAfterInstall = true
            }
            
        }
        
        //MARK: - CACHE DATA -
        
        func checkCacheCategory() {
            
            guard PersistenceManager.shared.countryDataForSearch != nil else { return }
            if let cachedData = UserDefaults.standard.data(forKey: "main_categories/\(strLang)"), let cachedCategories = try? JSONDecoder().decode([CategoryListModel].self, from: cachedData) {
                self.configCategories(cachedCategories)
            }
            
            getCategoryList(shouldLoading: arrayCategory.isEmpty, request: HomeViewNewModel.MakeCategoryRequest.Request(showOnScreen: 1))
        }
        
        func checkCacheBanners(serviceID: String, isCacheCheck: Bool = true) {
            if isCacheCheck {
                if let cachedData = UserDefaults.standard.data(forKey: "cacheBanners/\(serviceID)/\(strLang)"), let cachedBanners = try? JSONDecoder().decode([BannerModel].self, from: cachedData) {
                    self.configBanners(cachedBanners)
                }
            }
            
            getBannersList(serviceID: serviceID)
        }
        
        func checkCacheSubCategory(catId: Int, isCacheCheck: Bool = true) {
            if isCacheCheck {
                if let cachedData = UserDefaults.standard.data(forKey: "cacheSubcategory/\(catId)/\(strLang)"), let cachedSubCtg = try? JSONDecoder().decode([CategoryListModel].self, from: cachedData) {
                    self.configSubCategory(cachedSubCtg)
                }
            }
            
            getSubCategoryList(request: HomeViewNewModel.MakeCategoryRequest.Request(catId: catId))
        }
        
        func checkCachePropertiesAdv(catId: Int, isCacheCheck: Bool = true) {
            if isCacheCheck {
                if let cachedData = UserDefaults.standard.data(forKey: "cachePropertiesAdv/\(catId)/\(strLang)"), let cachedAdv = try? JSONDecoder().decode([PropertyData].self, from: cachedData) {
                    self.configPropertiesAdv(cachedAdv)
                }
            }
                    
            getPostedAdvList(request: HomeViewNewModel.GetAdvRequest.Request(page: 1,catId: catId, filterArray: PersistenceManager.shared.countryFilter))
        }
        
        func checkCachePostedMotors(catId: Int, isCacheCheck: Bool = true) {
            if isCacheCheck {
                if let cachedData = UserDefaults.standard.data(forKey: "cachePostedMotors/\(catId)/\(strLang)"), let cachedCars = try? JSONDecoder().decode([PostedCars].self, from: cachedData) {
                    self.configPostedMotors(cachedCars)
                }
            }
            
            print("** wk checkCachePostedMotors")
            
            getPostedMotorList(request: HomeViewNewModel.GetCarRequest.Request(page: 1,catId: catId, filterArray: PersistenceManager.shared.countryFilter))
        }
        
        func checkCacheNewPostedMotors(catId: Int, isCacheCheck: Bool = true) {
            if isCacheCheck {
                if let cachedData = UserDefaults.standard.data(forKey: "cacheNewPostedMotors/\(catId)/\(strLang)"), let cachedCars = try? JSONDecoder().decode([PostedCars].self, from: cachedData) {
                    self.configNewPostedMotors(cachedCars)
                }
            }
            
            print("** wk checkCachePostedMotors")
            var filter = PersistenceManager.shared.countryFilter
            filter?["is_new"] = "1"
            getNewPostedMotorList(request: HomeViewNewModel.GetCarRequest.Request(page: 1,catId: catId, filterArray: filter))
        }
        
        func checkCacheMotorMake(isCacheCheck: Bool = true) {
            if isCacheCheck {
                if let cachedData = UserDefaults.standard.data(forKey: "cacheMotorMake/\(strLang)"), let cachedMotorMake = try? JSONDecoder().decode([MotorMake].self, from: cachedData) {
                    self.configMotorMakes(cachedMotorMake)
                }
            }
            
            getCarMotorMakesList()
        }
        
        //MARK: - Config DATA -
        
        func configCategories(_ data: [CategoryListModel], isCacheCheck: Bool = true) {
            arrayCategory = data

            if let first = arrayCategory.first, selectedCategory == nil {
                onClickCategory(first, isCacheCheck: isCacheCheck)
            }
        }
        
        func configBanners(_ data: [BannerModel]) {
            self.arrayBanners = data
        }
        
        func configSubCategory(_ data: [CategoryListModel]) {
            arraySubCategory = data
        }
        
        func configPropertiesAdv(_ data: [PropertyData]) {
            arrayAdvObject = data
        }
        
        func configPostedMotors(_ data: [PostedCars]) {
            print("** wk configPostedMotors data: \(data.count)")
            arrayCarsObject = data
        }
        
        func configNewPostedMotors(_ data: [PostedCars]) {
            print("** wk configPostedMotors data: \(data.count)")
            arrayNewCarsObject = data
        }
        
        func configMotorMakes(_ data: [MotorMake]) {
            arrayMotorMakes = Array(data.prefix(6))
        }
        
        //MARK: - Actions -
        
        func onClickSelectLocation() {
            isPresentSelectLocation = true
        }
        
        func onClickDismissSelectLocation() {
            isPresentSelectLocation = false
            loadCacheOFSelectedLocationFromUserDefaults()
            selectedCategory = nil
            checkCacheCategory()
        }
        
        func onClickLanguage() {
            arrayCategory = []
            arraySubCategory = []
            arrayBanners = []
            arrayMotorMakes = []
            arrayAdvObject = []
            arrayCarsObject = []
            arrayNewCarsObject = []
            
            selectedCategory = nil
            loadCacheOFSelectedLocationFromUserDefaults()
            getCategoryList(shouldLoading: arrayCategory.isEmpty, isCacheCheck: false, request: HomeViewNewModel.MakeCategoryRequest.Request(showOnScreen: 1))
        }
        
        func onClickCategory(_ category: CategoryListModel, isCacheCheck: Bool = true) {
            selectedCategory = category
//            selectedSubCategory = nil
            
//            arrayBanners = []
//            
//            onBackGround(afterDelay: 0.2) {
//                onMain {
                    self.checkCacheBanners(serviceID: category.service_type ?? "")
//                }
//            }
            
            let serviceType = category.service_type ?? ""
            let categoryId = Int(category.id) ?? 0
            if serviceType == "property" {
                checkCacheSubCategory(catId: categoryId)
                checkCachePropertiesAdv(catId: categoryId)
            } else if serviceType == "motors" {
                checkCachePostedMotors(catId: categoryId)
                checkCacheMotorMake()
                checkCacheNewPostedMotors(catId: categoryId)
                getMotorQuickLinks()
            }
        }
        
//        func configCacheSubCategory() {
//            
//        }
        
        func onClickSubCategoryItem(_ subCtg: CategoryListModel) {
            print("** wk onClickSubCategoryItem 1")
            guard let selectedCategory else { return }
            
            let serviceType = selectedCategory.service_type ?? ""
            
            if serviceType == "property" {
                print("** wk onClickSubCategoryItem 2")
                selectedCategoryForPropertyList = subCtg
                isSearchResultOpen = true
            } else if serviceType == "motors" {
                print("** wk onClickSubCategoryItem 3")
                selectedQuickLinkItem = nil
                isCarsSearchResultOpen = true
            }
        }
        
        func getParamsForQuickLink() -> [String: String?] {
            var argsData: [String: String?] = [:]
            if let selectedQuickLinkItem, let jsonData = selectedQuickLinkItem["params"].stringValue.data(using: .utf8) {
                do {
                    if let paramsDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        Swift.print("** wk paramsDict: \(paramsDict)")
                        paramsDict.forEach({ data in
                            argsData[data.key] = "\(data.value)"
                        })
                    } else {
                        Swift.print("Failed to cast to dictionary")
                    }
                } catch {
                    Swift.print("Error parsing JSON: \(error)")
                }
            }
            
            print("** wk args: \(argsData)")
            return argsData
        }
        
        func onClickMotorQuickLink(_ item: JSON) {
            print("** wk onClickSubCategoryItem 1")
//            guard let selectedCategory else { return }
            
            selectedQuickLinkItem = item
            isCarsSearchResultOpen = true
        }
        
        func onClickPostedCar(_ item: PostedCars) {
            selectedPostedCar = item
            isPresentCarDetail = true
        }
        
        func onClickNewPostedCar(_ item: PostedCars) {
            selectedPostedCar = item
            isPresentCarDetail = true
        }
        
        func onClickMotorMakeBrandItem(_ item: MotorMake) {
            selectedMotorMakeBrandItem = item
            isPresentMotorMakeSingleView = true
        }
        
        //MARK: - API CALLS -
        
        func getCategoryList(shouldLoading: Bool = false, isCacheCheck: Bool = true, request: HomeViewNewModel.MakeCategoryRequest.Request) {
            print("** wk getCategoryList shouldLoading: \(shouldLoading)")
            if shouldLoading {
                self.isLoading = true
            }
            ViewModel.apiHandler.fetchCategoryList(afl: request.afl, catId: request.catId, showOnScreen: request.showOnScreen) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isLoading = false
                }
                if let categoryResponse = response {
                    if categoryResponse.count > 0 {
                        if let encodedData = try? JSONEncoder().encode(categoryResponse) {
                            UserDefaults.standard.set(encodedData, forKey: "main_categories/\(strLang)")
                        }
                    }
                    
                    self.configCategories(categoryResponse, isCacheCheck: isCacheCheck)
                }
            }
        }
        
        func getBannersList(shouldLoading: Bool = false, serviceID:String){
            if shouldLoading {
                self.isLoading = true
            }
            ViewModel.apiHandler.fetchBannersList(serviceID: serviceID) { [weak self] response, error in
                guard let self = self else { return }
                
                if shouldLoading {
                    self.isLoading = false
                }
                
                if error == nil {
                    self.configBanners(response)
                    
                    if let encodedData = try? JSONEncoder().encode(self.arrayBanners) {
                        UserDefaults.standard.set(encodedData, forKey: "cacheBanners/\(serviceID)/\(strLang)")
                    }
                } else {
                    
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
                    self.configSubCategory(categoryResponse)
                    
                    if let encodedData = try? JSONEncoder().encode(self.arraySubCategory) {
                        UserDefaults.standard.set(encodedData, forKey: "cacheSubcategory/\(request.catId ?? 0)/\(strLang)")
                    }
                }
            }
        }
        
        func getPostedAdvList(shouldLoading: Bool = false, request: HomeViewNewModel.GetAdvRequest.Request) {
            if shouldLoading {
                self.isLoading = true
            }
            
            ViewModel.apiHandler.fetchAddedAdvList(page: request.page, userId: request.userId, filterArray: request.filterArray, catId: request.catId) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isLoading = false
                }
                if let advResponse = response {
                    self.configPropertiesAdv(advResponse.advObject)
                    
                    if let encodedData = try? JSONEncoder().encode(advResponse.advObject) {
                        UserDefaults.standard.set(encodedData, forKey: "cachePropertiesAdv/\(request.catId ?? 0)/\(strLang)")
                    }
                }
                
                if(!error.debugDescription.isEmpty) {
                    print("errror", error.debugDescription)
                    errorMessage = error.debugDescription
                }
            }
        }
        
        func getPostedMotorList(shouldLoading: Bool = false, request: HomeViewNewModel.GetCarRequest.Request) {
            print("** wk getPostedMotorList 1")
            if shouldLoading {
                self.isCarLoading = true
            }
            
            ViewModel.apiHandler.fetchAddedCarList(page: request.page, userId: request.userId, filterArray: request.filterArray, catId: request.catId) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isCarLoading = false
                }
                
                print("** wk getPostedMotorList 2")
                
                if let carResponse = response {
                    print("** wk getPostedMotorList 3")
                    self.configPostedMotors(carResponse.carObject)
                    
                    if let encodedData = try? JSONEncoder().encode(carResponse.carObject) {
                        UserDefaults.standard.set(encodedData, forKey: "cachePostedMotors/\(request.catId ?? 0)/\(strLang)")
                    }
//                    totalPageCount = Int(round(Double(carResponse.total / carResponse.per_page)))
//                    self.arrayCarsObject =   self.arrayCarsObject + carResponse.carObject
//                    totaladCount = carResponse.total
                }
                
                if(!error.debugDescription.isEmpty) {
                    print("** wk getPostedMotorList 4 error: \(error.debugDescription)")
                    print("errror", error.debugDescription)
                    errorMessage = error.debugDescription
                }
            }
        }
        
        func getNewPostedMotorList(shouldLoading: Bool = false, request: HomeViewNewModel.GetCarRequest.Request) {
            print("** wk getPostedMotorList 1")
            if shouldLoading {
                self.isCarLoading = true
            }
            
            ViewModel.apiHandler.fetchAddedCarList(page: request.page, userId: request.userId, filterArray: request.filterArray, catId: request.catId) { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isCarLoading = false
                }
                
                print("** wk getPostedMotorList 2")
                
                if let carResponse = response {
                    print("** wk getPostedMotorList 3")
                    self.configNewPostedMotors(carResponse.carObject)
                    
                    if let encodedData = try? JSONEncoder().encode(carResponse.carObject) {
                        UserDefaults.standard.set(encodedData, forKey: "cacheNewPostedMotors/\(request.catId ?? 0)/\(strLang)")
                    }
//                    totalPageCount = Int(round(Double(carResponse.total / carResponse.per_page)))
//                    self.arrayCarsObject =   self.arrayCarsObject + carResponse.carObject
//                    totaladCount = carResponse.total
                }
                
                if(!error.debugDescription.isEmpty) {
                    print("** wk getPostedMotorList 4 error: \(error.debugDescription)")
                    print("errror", error.debugDescription)
                    errorMessage = error.debugDescription
                }
            }
        }
        
        func getMotorQuickLinks(shouldLoading: Bool = false){
            if shouldLoading {
                isLoading = true
            }
            
            ViewModel.apiHandler.fetchMotorQuickLinks() { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let error = error {
                    
                } else {
                    arrayMotorQuickLinks = response.arrayValue
                    print("** wk response: \(response)")
                }
                
//                var countries = response
//                if let selected = selectedCountryWithState {
//                    countries = countries.filter({$0.id != selected.country.id})
//                }
//                
//                self.arrayCountries = countries
//                self.arrayCountriesTemp = self.arrayCountries
            }
        }
        
        func getCarMotorMakesList(shouldLoading: Bool = false) {
            if shouldLoading {
                self.isCarLoading = true
            }
            
            ViewModel.apiHandler.fetchCarMake() { [weak self] response, error in
                guard let self = self else { return }
                if shouldLoading {
                    self.isLoading = false
                }
                self.configMotorMakes(response)
                if let encodedData = try? JSONEncoder().encode(response) {
                    UserDefaults.standard.set(encodedData, forKey: "cacheMotorMake/\(strLang)")
                }
            }
        }
        
        func loadCacheOFSelectedLocationFromUserDefaults() {
            guard let selected = PersistenceManager.shared.countryDataForSearch else {
                isPresentSelectLocation = strSelectedLocation.isEmpty
                return
            }
            
            let stateModel = selected.arrayState.filter({ $0.id == selected.selectedStateID }).first
            let stateName = strLang == "en" ? trim(stateModel?.name) : trim(stateModel?.translation)
            let countryName = strLang == "en" ? trim(selected.country.iso3) : trim(selected.country.translation)
            strSelectedLocation = [stateName, countryName].joined(separator: ", ")
        }
    }
}



