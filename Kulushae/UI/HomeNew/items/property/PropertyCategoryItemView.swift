//
//  PropertyCategoryItemView.swift
//  Kulushae
//
//  Created by Waseem  on 01/01/2025.
//

import SwiftUI

struct PropertyCategoryItemView: View {
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
                    
                    if !dataHandler.arraySubCategory.isEmpty {
                        quickLinksView
                    }
                    
                    if !dataHandler.arrayAdvObject.isEmpty {
                        propertiesSection
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
            .onAppear {
                print("** wk dataHandler: \(dataHandler)")
                print("** wk scrollOffset: \(dataHandler.scrollOffset)")
            }
        }
    }
    
    private var CarouselSection: some View {
        CarouselNewView(carList: dataHandler.arrayBanners, isSelectedId: $dataHandler.selectedRecentId, selectedType: $dataHandler.selectedProductType, isSelected: $dataHandler.isOpenCarDetails)
            .padding(.top, 10)
            .padding(.bottom, 25)
            .padding(.leading, 5)
            .padding(.trailing, 5)
    }
    
    private var quickLinksView: some View {
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
            
            SubCategoryNewView(categories: dataHandler.arraySubCategory, onClickSubCtg: dataHandler.onClickSubCategoryItem)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 0)
                .padding(.bottom, 15)
                .padding(.leading, 10)
        }
        
    }
    
    private var propertiesSection: some View {
        Group {
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
                        //                            selectedCategory = ""
                        dataHandler.selectedCategoryForPropertyList = dataHandler.selectedCategory
                        dataHandler.isSearchResultOpen = true
                    }) {
                        Text(LocalizedStringKey("See All"))
                            .font(.roboto_14())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .padding(.trailing, 15)
                    }
                }
                
                RecentAdNewView(
                    advList: $dataHandler.arrayAdvObject,
                    isSelectedId: $dataHandler.selectedRecentId,
                    selectedType: $dataHandler.selectedProductType,
                    isSelected: $dataHandler.isDetailViewActive,
                    isFavourite: $dataHandler.isFavourite,
                    isLoginSheetPresented: $isLoginSheetPresented,
                    isFavClicked: $dataHandler.isFavClicked
                )
                .padding(.top, 15)
                .padding(.leading, 5)
                .padding(.bottom, 25)
            }
        }
    }
}

#Preview {
    PropertyCategoryItemView(dataHandler: .init(language: "en"), isLoginSheetPresented: .constant(false))
}
