//
//  HomeView.swift
//  Easy Buy
//
//  Created by ios on 02/10/2023.
//


import SwiftUI
import CoreLocation
import Combine

 let categoryCacheKey = "cachedCategoryData"
 let lastFetchTimeKey = "lastCategoryFetchTime"


struct HomeView: View {
    
    @StateObject var locationViewModel: LocationViewModel = LocationViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var isLoginSheetPresented: Bool
    @State private var isPresented = false
    @StateObject var dataHandler = HomeViewModel.ViewModel()
    @StateObject var favDataHandler = ProductDetailsViewModel.ViewModel()
    @State var isOpenAdsView = false
    @State var isSearchScreenOpen = false
    @State var selectedCity: String = ""
    @State var selectedRecentId: Int = -1
    @State var selectedProductType: String = ""
    @State private var isDetailViewActive = false
    @State private var filteredCategories: [CategoryListModel] = []
    @State var isSearchResultOpen: Bool = false
    @State var isCarsSearchResultOpen: Bool = false
    @State var isProfileOpen: Bool = false
    @State var selectedCategory: String = ""
    @State var isFavourite: Bool = false
    @State var isFavClicked: Bool = false
    @State var isOpenCarDetails: Bool = false
    @State var categoryType: String = ""

    @State var newCatIdVal = -1
    @State private var isNavigationActive = false
    @State var isOpenDetails: Bool = false
    // Handling Cache for 5 hours
    private let expiryTime: TimeInterval = 5 * 60 * 60 // 5 hours
    
    // handling subcategory and category selection:
    @State private var shouldReloadData = false // To control data reload
    @State private var isSubcategoryListActive = false // For subcategory navigation

    
    
    func getCategoryList() {
        let now = Date()
        
        if let lastFetchTime = UserDefaults.standard.object(forKey: lastFetchTimeKey) as? Date,
           now.timeIntervalSince(lastFetchTime) < expiryTime,
           let cachedData = UserDefaults.standard.data(forKey: categoryCacheKey),
           let cachedCategories = try? JSONDecoder().decode([CategoryListModel].self, from: cachedData) {
            
            // Use cached data, update on the main thread
            DispatchQueue.main.async {
                self.dataHandler.categoryObject = cachedCategories
            }
            print("Loaded cached category data")
            
        } else {
            // Fetch new data
            dataHandler.getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(showOnScreen: 1))
        }
    }
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack(alignment: .bottom) {
                VStack {
                    headerView
                    if dataHandler.categoryObject.count > 0 {
                        categoryView
                    }
                    searchButton
                    contentScrollView
                }
                .background(Color.appBackgroundColor)
                .frame(width: .screenWidth)
                .onAppear {
                    loadInitialData()
                    self.selectedCategory = dataHandler.selectedCategory
                }
                
                loginBottomSheet
            }
            .padding(.bottom, -15)
            .onChange(of: isFavClicked) { newIsFavClicked in
                if newIsFavClicked {
                    addFavourite(productId: selectedRecentId, isLike: isFavourite, type: selectedProductType)
                }
            }
            .background(
                            navigationLinks
                        )
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            languageButton
        }
        .padding(.top, 60)
    }
    
    private var languageButton: some View {
        Button(action: {
            let newLanguage = languageManager.currentLanguage == "en" ? "ar" : "en"
            UserDefaults.standard.set(newLanguage, forKey: "AppLanguage")
            languageManager.setLanguage(newLanguage)
            dataHandler.getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(showOnScreen: 1))
        }) {
            Image(languageManager.currentLanguage == "en" ? "arabic" : "english")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.black)
                .padding(10)
        }
    }
    
    private var categoryView: some View {

        return CategoryView(categories: $dataHandler.categoryObject, selectedCategory: $selectedCategory, isOpen: $isSearchResultOpen, isMotorOpen: $isCarsSearchResultOpen, hideImage: false, onCategorySelected: handleMainCategorySelection)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.bottom, 15)
                .padding(.leading, 10)
    }
    
    private var subCategoryView: some View {
        Group {
            HStack {
                Text(LocalizedStringKey("Quick Click"))
                    .fontWeight(.bold)
                    .font(.roboto_20())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .padding(.leading, 15)
                Spacer()
            }.padding(.top, 10)
                .padding(.bottom, 5)
        SubCategoryView(categories: $dataHandler.subCategoryObject, selectedCategory: $selectedCategory, isOpen: $isSearchResultOpen, isMotorOpen: $isCarsSearchResultOpen, hideImage: false,onCategorySelected: handleSubCategorySelection)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 0)
            .padding(.bottom, 15)
            .padding(.leading, 10)
    }

    }
    
    private func handleMainCategorySelection(_ categoryId: String, _ serviceType: String) {
        selectedCategory = categoryId
        shouldReloadData = true // Trigger data reload on main category selection
        
        dataHandler.getPostedAdvList(request: HomeViewModel.GetAdvRequest.Request(page: 1,catId: Int(categoryId)))
        dataHandler.getPostedMotorList(request: HomeViewModel.GetCarRequest.Request(page: 1,catId: Int(categoryId)))
        dataHandler.getSubCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(catId: Int(categoryId)))
        dataHandler.getBannersList(serviceID: serviceType)
    }

    private func handleSubCategorySelection(_ subCategoryId: String) {
        selectedCategory = subCategoryId
        isSubcategoryListActive = true // Trigger navigation on subcategory selection
    }
    
    
    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                if dataHandler.bannerList.count > 0 {
                    CarouselSection
                }
                if $dataHandler.subCategoryObject.count > 0 {
                    subCategoryView
                }
                propertiesSection
                carsSection
            }
            .frame(width: .screenWidth)
            // Remove the padding here
        }
    }
    
    private var welcomeText: some View {
        HStack {
            Text(LocalizedStringKey("Buy Wisely, Sell Smart"))
                .font(.roboto_40())
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .frame(width: 210)
                .padding(.leading, 15)
            Spacer()
        }
        .frame(width: .screenWidth * 0.9)
        .padding(.bottom, 15)
    }
    
    private var searchButton: some View {
        Button(action: {
            isSearchScreenOpen = true
        }) {
            HStack {
                Spacer()
                HStack {
                    Text(LocalizedStringKey("Search here..."))
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .padding()
                        .foregroundColor(Color.black)
                    Spacer()
                    Image(uiImage: UIImage(named: "icn_magnet") ?? UIImage())
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 18.5)
                }
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).inset(by: -0.5).stroke(Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0), lineWidth: 1))
                Spacer()
            }
        }
        .padding(.bottom, 0)
        .padding(.leading, 5)
        .padding(.trailing, 5)
        .padding(.top, 15)
    }
    
    private var CarouselSection: some View {
        

            CarouselView(carList: $dataHandler.bannerList, isSelectedId: $selectedRecentId, selectedType: $selectedProductType, isSelected: $isOpenCarDetails, isFavourite: $isFavourite, isLoginSheetPresented: $isLoginSheetPresented, isFavClicked: $isFavClicked)
                .padding(.top, 10)
                .padding(.bottom, 25)
                .padding(.leading, 5)
                .padding(.trailing, 5)
        
    }
    
    private var propertiesSection: some View {
        Group {
            if !dataHandler.advObject.isEmpty {
                VStack {
                    HStack {
                        Text(LocalizedStringKey("Properties"))
                            .fontWeight(.bold)
                            .font(.roboto_20())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .padding(.leading, 15)
                        Spacer()
                        Button(action: {
                            selectedCategory = ""
                            isSearchResultOpen = true
                        }) {
                            Text(LocalizedStringKey("See All"))
                                .font(.roboto_14())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor(Color.black)
                                .padding(.trailing, 15)
                        }
                    }
                    
                    RecentAdView(advList: $dataHandler.advObject, isSelectedId: $selectedRecentId, selectedType: $selectedProductType, isSelected: $isDetailViewActive, isFavourite: $isFavourite, isLoginSheetPresented: $isLoginSheetPresented, isFavClicked: $isFavClicked)
                        .padding(.top, 15)
                        .padding(.leading, 5)
                        .padding(.bottom, 25)
                }
            } else {
                EmptyView() // Return an empty view if there's no content
            }
        }
    }

    private var carsSection: some View {
        Group {
            if !dataHandler.carObject.isEmpty {
                VStack {
                    HStack {
                        Text(LocalizedStringKey("Cars"))
                            .fontWeight(.bold)
                            .font(.roboto_20())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .padding(.leading, 15)
                        
                        Spacer()
                        
                        Button(action: {
                            isCarsSearchResultOpen = true
                        }) {
                            Text(LocalizedStringKey("See All"))
                                .font(.roboto_14())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor(Color.black)
                                .padding(.trailing, 15)
                        }
                    }

                    RecentCarsView(carList: $dataHandler.carObject, isSelectedId: $selectedRecentId, selectedType: $selectedProductType, isSelected: $isOpenCarDetails, isFavourite: $isFavourite, isLoginSheetPresented: $isLoginSheetPresented, isFavClicked: $isFavClicked)
                        .padding(.top, 15)
                        .padding(.leading, 5)
                }
            } else {
                EmptyView() // Return an empty view if there's no content
            }
        }
    }
    
    private var loginBottomSheet: some View {
        BottomSheetView(isOpen: $isLoginSheetPresented, maxHeight: 690) {
            LoginUserView(isOpen: $isLoginSheetPresented)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: .screenWidth, height: isLoginSheetPresented ? .screenHeight : 0.0, alignment: .bottom)
        .opacity(isLoginSheetPresented ? 1.0 : 0.0)
    }
    
    private func loadInitialData() {
        self.getCategoryList()
        dataHandler.getPostedAdvList(request: HomeViewModel.GetAdvRequest.Request(page: 1))
        dataHandler.getPostedMotorList(request: HomeViewModel.GetCarRequest.Request(page: 1))
        dataHandler.getSubCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(catId: 2))
        dataHandler.getBannersList(serviceID: "classified")
    }
    
    private func addFavourite(productId: Int, isLike: Bool, type: String) {
        favDataHandler.addFavDetails(request: ProductDetailsViewModel.AddFavourite.Request(like: isLike, itemId: productId, type: type))
        isFavClicked = false
    }
    
    private var navigationLinks: some View {
            Group {
                NavigationLink("", destination: SearchScreenView(), isActive: $isSearchScreenOpen)
                NavigationLink("", destination: SearchResultView(selectedCatId: selectedCategory), isActive: $isSubcategoryListActive)
                NavigationLink("", destination: CarsSearchResultView(selectedCatId: selectedCategory), isActive: $isCarsSearchResultOpen)
                NavigationLink("", destination: ProfileView(), isActive: $isProfileOpen)

                if selectedRecentId != -1 {
                    if !dataHandler.advObject.isEmpty {
                        NavigationLink("", destination: PostedAdDetailsView(productId: selectedRecentId), isActive: $isDetailViewActive)
                    }
                    if !dataHandler.carObject.isEmpty {
                        NavigationLink("", destination: CarDetailsView(motorId: selectedRecentId), isActive: $isOpenCarDetails)
                    }
                }
            }
        }
    
}



// struct HomeView_Previews: PreviewProvider {
//     static var previews: some View {
//         HomeView()
//             .environmentObject(LanguageManager())
//     }
// }
