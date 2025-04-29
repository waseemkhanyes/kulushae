//
//  MotoresCategoryItemView.swift
//  Kulushae
//
//  Created by Waseem  on 01/01/2025.
//

import SwiftUI

struct MotoresCategoryItemView: View {
    @ObservedObject var dataHandler: HomeViewNewModel.ViewModel
    @Binding var isLoginSheetPresented: Bool
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        GeometryReader { geometry in
            ObservableScrollView(scrollOffset: $dataHandler.scrollOffset.onChange({ value in
                if value > 0.0 && !dataHandler.isHideCategoryImage {
                    withAnimation() {
                        dataHandler.isHideCategoryImage = true
                    }
                } else if value <= 0.0 && dataHandler.isHideCategoryImage {
                    withAnimation() {
                        dataHandler.isHideCategoryImage = false
                    }
                }
            })) { proxy in
                VStack(alignment: .leading) {
                    
                    if !dataHandler.arrayBanners.isEmpty {
                        CarouselSection
                    }
                    
                    
                        
                        if !dataHandler.arrayMotorMakes.isEmpty {
                            motorBrandsView
                        }
                        
                        if !dataHandler.arrayMotorQuickLinks.isEmpty {
                            motorQuickLinks
                        }
                        
                        if !dataHandler.arrayNewCarsObject.isEmpty {
                            newMotorsAds
                        }
                        
                        if !dataHandler.arrayCarsObject.isEmpty {
                            motorsRecentAds
                        }
                    }
                
                .frame(width: .screenWidth)
                .background(GeometryReader { contentGeometry in
                    Color.clear
                        .onAppear {
                            // Capture the content height after it appears
                            self.dataHandler.contentHeight = contentGeometry.size.height
                            self.dataHandler.scrollEnabled = self.dataHandler.contentHeight > geometry.size.height
                        }
                        .onChange(of: contentGeometry.size.height) { newHeight in
                            // Update the content height on change
                            self.dataHandler.contentHeight = newHeight
                            self.dataHandler.scrollEnabled = self.dataHandler.contentHeight > geometry.size.height
                        }
                })
            }
            .scrollDisabled(!dataHandler.scrollEnabled)
        }
    }
    
    private var CarouselSection: some View {
        CarouselNewView(carList: dataHandler.arrayBanners, isSelectedId: $dataHandler.selectedRecentId, selectedType: $dataHandler.selectedProductType, isSelected: $dataHandler.isOpenCarDetails)
            .padding(.top, 10)
            .padding(.bottom, 25)
            .padding(.leading, 5)
            .padding(.trailing, 5)
    }
    
    private var motorBrandsView: some View {
        Group {
            VStack {
                HStack {
                    Text(LocalizedStringKey("Brands"))
                        .fontWeight(.bold)
                        .font(.roboto_20())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.black)
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                    Button(action: {
                        dataHandler.isPresentAllMotorMakeBrands = true
                    }) {
                        Text(LocalizedStringKey("See All"))
                            .font(.roboto_14())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .padding(.trailing, 15)
                    }
                }
                
                BrandsMotorMakesView(arrayMakes: dataHandler.arrayMotorMakes, action: dataHandler.onClickMotorMakeBrandItem)
                    .padding(.top, 15)
                    .padding(.bottom, 25)
            }
        }
        
    }
    
    private var motorQuickLinks: some View {
        Group {
            HStack {
                Text(LocalizedStringKey("Quick Links"))
                    .fontWeight(.bold)
                    .font(.roboto_20())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .padding(.leading, 15)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            MotorQuickLinksItemView(categories: dataHandler.arrayMotorQuickLinks, onClickSubCtg: dataHandler.onClickMotorQuickLink)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 0)
                .padding(.bottom, 15)
                .padding(.leading, 10)
        }
        
    }
    
    private var newMotorsAds: some View {
        Group {
            VStack {
                HStack {
                    Text(LocalizedStringKey("New Cars"))
                        .fontWeight(.bold)
                        .font(.roboto_20())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.black)
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                    Button(action: {
                        //                            selectedCategory = ""
                        dataHandler.isNewCarsSearchResultOpen = true
                    }) {
                        Text(LocalizedStringKey("See All"))
                            .font(.roboto_14())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .padding(.trailing, 15)
                    }
                }
                
                RecentCarAdsNewView(
                    advList: $dataHandler.arrayNewCarsObject,
                    isSelectedId: $dataHandler.selectedRecentId,
                    selectedType: $dataHandler.selectedProductType,
                    isSelected: $dataHandler.isDetailViewActive,
                    isFavourite: $dataHandler.isFavourite,
                    isLoginSheetPresented: $isLoginSheetPresented,
                    isFavClicked: $dataHandler.isFavClicked,
                    action: dataHandler.onClickNewPostedCar
                )
                .padding(.top, 15)
                .padding(.leading, 5)
                .padding(.bottom, 25)
            }
        }
    }
    
    private var motorsRecentAds: some View {
        Group {
            VStack {
                HStack {
                    Text(LocalizedStringKey("Recent Ads"))
                        .fontWeight(.bold)
                        .font(.roboto_20())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.black)
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                    Button(action: {
                        //                            selectedCategory = ""
                        dataHandler.arrayFilters = []
                        dataHandler.isCarsSearchResultOpen = true
                    }) {
                        Text(LocalizedStringKey("See All"))
                            .font(.roboto_14())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .padding(.trailing, 15)
                    }
                }
                
                RecentCarAdsNewView(
                    advList: $dataHandler.arrayCarsObject,
                    isSelectedId: $dataHandler.selectedRecentId,
                    selectedType: $dataHandler.selectedProductType,
                    isSelected: $dataHandler.isDetailViewActive,
                    isFavourite: $dataHandler.isFavourite,
                    isLoginSheetPresented: $isLoginSheetPresented,
                    isFavClicked: $dataHandler.isFavClicked,
                    action: dataHandler.onClickPostedCar
                )
                .padding(.top, 15)
                .padding(.leading, 5)
                .padding(.bottom, 25)
            }
        }
    }
}

#Preview {
    MotoresCategoryItemView(dataHandler: .init(language: "en"), isLoginSheetPresented: .constant(false))
}
