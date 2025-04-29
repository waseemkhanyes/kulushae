//
//  HomeViewNew.swift
//  Kulushae
//
//  Created by Waseem  on 09/11/2024.
//

import SwiftUI
import CoreLocation
import Combine
import SDWebImageSwiftUI

struct HomeViewNew: View {
    
    @StateObject var locationViewModel: LocationViewModel = LocationViewModel()
    @StateObject var dataHandler = HomeViewNewModel.ViewModel(language: LanguageManager.init().currentLanguage)
    @StateObject var favDataHandler = ProductDetailsViewModel.ViewModel()
    
    @EnvironmentObject var languageManager: LanguageManager
    
    @Binding var isLoginSheetPresented: Bool
    
    @State private var contentHeight: CGFloat = 0
    @State private var scrollEnabled: Bool = true
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack(alignment: .bottom) {
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        headerView
                        
                        if !dataHandler.arrayCategory.isEmpty {
                            categoryView
                        }
                        
                        if dataHandler.selectedCategory?.service_type ?? "" == "property" {
                            searchButton
                        } else {
                            searchMotorButton
                        }
                        
                    }
                    .padding(.bottom, 10)
                    .shadowColor(show: dataHandler.scrollOffset > 0.0)
                    let serviceType = ServiceType(rawValue: trim(dataHandler.selectedCategory?.service_type))
                    if serviceType == .Property {
                        PropertyCategoryItemView(dataHandler: dataHandler, isLoginSheetPresented: $isLoginSheetPresented)
                    } else if serviceType == .Motor {
                        MotoresCategoryItemView(dataHandler: dataHandler, isLoginSheetPresented: $isLoginSheetPresented)
                    } else {
                        Spacer()
                    }
                }
                .background(Color.appBackgroundColor)
                .frame(width: .screenWidth)
                
                loginBottomSheet
            }
            .onAppear {
                print("** wk language: \(UserDefaults.standard.string(forKey: "AppLanguage") ?? "ena")")
            }
            .padding(.bottom, -15)
            .background(
                navigationLinks
            )
        }
        .popUpBack(show: dataHandler.isPresentSelectLocation || dataHandler.isSelectLanguageAfterInstall)
        .fullScreenCover(isPresented: $dataHandler.isPresentSelectLocation) {
            SelectLocationPopupView(viewModel: .init(type: .ForSearch, handler: dataHandler.onClickDismissSelectLocation))
                .clearBackground()
        }
        .fullScreenCover(isPresented: $dataHandler.isSelectLanguageAfterInstall) {
            SelectLanguagePopupView {
                dataHandler.isSelectLanguageAfterInstall = false
                dataHandler.loadCacheOFSelectedLocationFromUserDefaults()
            }
            .clearBackground()
        }
        .sheet(isPresented: $dataHandler.isPresentFilterSheet) {
            MotorCategoryFilterView(viewModel: .init(handler: { data in
                dataHandler.isPresentFilterSheet = false
                if let data {
                    dataHandler.arrayFilters = data
                    dataHandler.isCarsSearchResultOpen = true
                }
            }))
        }
    }
    
    private var languageButton: some View {
        Button(action: {
            let newLanguage = languageManager.currentLanguage == "en" ? "ar" : "en"
            UserDefaults.standard.set(newLanguage, forKey: "AppLanguage")
            languageManager.setLanguage(newLanguage)
            
            print("** wk language1: \(UserDefaults.standard.string(forKey: "AppLanguage") ?? "en")")
            
            dataHandler.onClickLanguage()
        }) {
            Image(languageManager.currentLanguage == "en" ? "arabic" : "english")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.black)
                .padding(10)
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 0) {
            addressView
            
            Spacer()
            
            languageButton
        }
        .frame(height: 50)
        .padding(.top, safeAreaInsets.top)
    }
    
    var addressView: some View {
        Button(action: {
            dataHandler.onClickSelectLocation()
        }) {
            HStack(spacing: 0) {
                Image("location_pin")
                
                Text(dataHandler.strSelectedLocation)
                    .font(.roboto_14())
                    .foregroundStyle(.black)
                    .padding(.leading, 8)
            }
            .frame(height: 17)
            .padding(.leading, 18)
        }
    }
    
    var categoryView: some View {
        return CategoryNewView(categories: dataHandler.arrayCategory, selected: dataHandler.selectedCategory, hideImage: dataHandler.isHideCategoryImage) { category in
            dataHandler.onClickCategory(category)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
        .padding(.bottom, 15)
        .padding(.leading, 10)
    }
    
    private var searchButton: some View {
        Button(action: {
            dataHandler.isSearchScreenOpen = true
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
    
    private var searchMotorButton: some View {
        HStack(spacing: 0) {
            Button(action: {
                dataHandler.isSearchScreenOpen = true
            }) {
                HStack(spacing: 0) {
                    Image(uiImage: UIImage(named: "icn_magnet") ?? UIImage())
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.leading, 18.5)
                    
                    Text(LocalizedStringKey("Search here..."))
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .padding()
                        .foregroundColor(Color.black)
                    Spacer()
                }
            }
            
            Button(action: {
                dataHandler.isPresentFilterSheet = true
            }) {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {}
                        .frame(maxHeight: .infinity)
                        .frame(width: 1)
                        .background(.black.opacity(0.3))
                    
                    Spacer()
                    
                    Image(.filter)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                    
                    Spacer()
                }
                .frame(width: 60)
            }
        }
        .frame(height: 50)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).inset(by: -0.5).stroke(Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0), lineWidth: 1))
        .padding(.horizontal, 14)
        .padding(.top, 15)
    }
    

    
    private var loginBottomSheet: some View {
        BottomSheetView(isOpen: $isLoginSheetPresented, maxHeight: 690) {
            LoginUserView(isOpen: $isLoginSheetPresented)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: .screenWidth, height: isLoginSheetPresented ? .screenHeight : 0.0, alignment: .bottom)
        .opacity(isLoginSheetPresented ? 1.0 : 0.0)
    }
    
    private var navigationLinks: some View {
        Group {
            NavigationLink("", destination: SearchScreenView(), isActive: $dataHandler.isSearchScreenOpen)
            
            NavigationLink("", destination: PropertyListScreenView(dataHandler: .init(category: dataHandler.selectedCategoryForPropertyList)),
                           isActive: $dataHandler.isSearchResultOpen)
            
            NavigationLink(
                "",
                destination: CarListScreenView(
                    dataHandler: .init(
                        categoryId: dataHandler.selectedCategory?.id ?? "",
                        search: "",
                        userId: nil,
                        argsDictionary: dataHandler.getParamsForQuickLink(),
                        arrayFilters: dataHandler.arrayFilters
                    )
                ),
                isActive: $dataHandler.isCarsSearchResultOpen
            )
            
            NavigationLink("", destination: CarListScreenView(dataHandler: .init(categoryId: dataHandler.selectedCategory?.id ?? "", search: "", userId: nil, isNew: true)), isActive: $dataHandler.isNewCarsSearchResultOpen)
            
            NavigationLink("", destination: CarDetailsView(motorId: dataHandler.selectedPostedCar?.id ?? 0) ,
                           isActive: $dataHandler.isPresentCarDetail)
            .navigationBarBackButtonHidden(true)
            
            if let category = dataHandler.selectedCategory {
                NavigationLink("", destination: MotorMakesListView(dataHandler: .init(category: category)), isActive: $dataHandler.isPresentAllMotorMakeBrands)
            }
            
            if dataHandler.selectedRecentId != -1 {
                if !dataHandler.arrayAdvObject.isEmpty {
                    NavigationLink("", destination: PostedAdDetailsView(productId: dataHandler.selectedRecentId), isActive: $dataHandler.isDetailViewActive)
                }
            }
            
            if let category = dataHandler.selectedCategory, let selectedMotor = dataHandler.selectedMotorMakeBrandItem {
                NavigationLink("", destination: MotorMakeSingleView(dataHandler: .init(category: category, motorMake: selectedMotor)), isActive: $dataHandler.isPresentMotorMakeSingleView)
            }
        }
    }
}

#Preview {
    HomeViewNew(isLoginSheetPresented:  .constant(false))
}
