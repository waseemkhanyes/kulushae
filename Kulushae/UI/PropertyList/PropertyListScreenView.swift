//
//  PropertyListScreenView.swift
//  Kulushae
//
//  Created by Waseem  on 30/11/2024.
//

import SwiftUI
import Kingfisher
import MapKit

struct PropertyListScreenView: View {
    @StateObject var dataHandler: PropertyListScreenViewModel.ViewModel
    
    @EnvironmentObject var languageManager: LanguageManager
    
    @StateObject var favDataHandler = ProductDetailsViewModel.ViewModel()
    @State var totalNumber = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    // Define a grid layout with 2 columns
    let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            if dataHandler.advObject.isEmpty && !dataHandler.isLoading && dataHandler.arraySubCategory.isEmpty {
                NoItemFoundView(isShowBackButton: true)
            } else {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        topView
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                MultiSelectionNewButton(title: "All" , isSelected: dataHandler.selectedSubCategory == nil) {
                                    dataHandler.selectedSubCategory = nil
                                    dataHandler.checkCachePropertiesAdv()
                                }
                                .padding(.leading, 16)
                                
                                ForEach(Array(dataHandler.arraySubCategory.enumerated()), id: \.element.id) { index, subCtg in
                                    MultiSelectionNewButton(title: subCtg.title ?? "" , isSelected: dataHandler.selectedSubCategory?.id ?? "" == subCtg.id) {
                                        dataHandler.selectedSubCategory = subCtg
                                        dataHandler.checkCachePropertiesAdv()
                                    }
                                }
                            }
                        }
                        .frame(height: 40)
                        
                        if dataHandler.advObject.isEmpty {
                            VStack(spacing: 0) {
                                NoItemFoundView(isShowBackButton: false)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ObservableScrollView(showsIndicators: false, scrollOffset: $dataHandler.scrollOffset) { _ in
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 2), spacing: 15) {
                                    ForEach(Array(dataHandler.advObject.enumerated()), id: \.element.id) { index, property in
                                        PropertyItemView(property: property) {
                                            let type = dataHandler.advObject[index].type ?? ""
                                            if(dataHandler.advObject[index].isFavorite ?? false) {
                                                dataHandler.advObject[index].isFavorite = false
                                                addFavourite(productId: dataHandler.advObject[index].id ?? 0, isLike: false, index: index, type: type)
                                            } else {
                                                dataHandler.advObject[index].isFavorite = true
                                                addFavourite(productId: dataHandler.advObject[index].id ?? 0, isLike: true, index: index, type: type)
                                            }
                                        }
                                        .onTapGesture {
                                            dataHandler.onClickProperty(property)
                                        }
                                        .onAppear {
                                            if index == dataHandler.advObject.count - 1 {
                                                dataHandler.loadMoreData()
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 18)
                            }
                        }
                    }
                    .sheet(isPresented: $dataHandler.isOpenLocSearchView) {
                        SearchWithLocationView(isOpen: $dataHandler.isOpenLocSearchView, selectedLocationArray: $dataHandler.searchLocationArray, title: "Search by Location")
                    }
                    BottomSheetView(isOpen: $dataHandler.isOpenFilterView, maxHeight: .screenHeight * 0.8) {
                        PropertyFilterView(argsDictionary: $dataHandler.argsDictionary, isOpen: $dataHandler.isOpenFilterView, catId: Int(dataHandler.selectedCatId) ?? 0)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: .screenWidth, height: dataHandler.isOpenFilterView ? .screenHeight : 0, alignment: .bottom)
                    .opacity(dataHandler.isOpenFilterView ? 1.0 : 0.0)
                }
            }
        }
        .onChange(of: dataHandler.searchKey) { newKey in
            if !dataHandler.searchKey.isEmpty {
                dataHandler.advObject = []
                dataHandler.currentPage = 1
                dataHandler.argsDictionary["keyword"] = newKey
            }
            dataHandler.loadMoreData()
        }
        .navigationBarBackButtonHidden(true)
        
        if let selectedId = dataHandler.selectedProperty?.id {
            NavigationLink("", destination: PostedAdDetailsView(productId: selectedId), isActive: $dataHandler.isDetailViewActive)
                .navigationBarBackButtonHidden(true)
        }
    }
    
    func addFavourite(productId: Int, isLike: Bool, index: Int, type: String) {
        favDataHandler.addFavDetails(request: ProductDetailsViewModel.AddFavourite.Request(like: isLike, itemId: productId, type: type))
        //        dataHandler.advObject[index].isFavorite  = !(dataHandler.advObject[index].isFavorite ?? false)
    }
    
    func itemIsLast(item: PropertyData) -> Bool {
        return item == dataHandler.advObject.last
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            ZStack {
                Image("back")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 15, alignment: .center)
                    .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
            }
            .frame(width: 35, height: 35)
//            .padding(.leading, 9)
            .onTapGesture { dismiss() }
            
            
//            HStack(spacing: 10) {
                Text(LocalizedStringKey("Result Found"))
                    .font(.roboto_22_semi())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .padding(.leading, 10)
                
//                Text(String(dataHandler.totaladCount))
//                    .font(.roboto_22_semi())
//                    .foregroundColor(Color.black)
                
//            }
            
            Spacer()
            
            Button(action: {
                dataHandler.isOpenFilterView = true
            }) {
                Image(.imgFilter)
                    .padding(13)
            }
            .padding(.trailing, 2)
        }
        .padding(.top, safeAreaInsets.top)
        .padding(.leading, 13)
        .padding(.trailing, 18)
        .background(.white)
        .shadowColor(show: dataHandler.scrollOffset > 0.0)
    }
}

fileprivate struct PropertyItemView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    
    var property: PropertyData
    
    var favouriteAction: (()->())? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageAndHeartView
            
            VStack(alignment: .leading, spacing: 0) {
                priceView
                
                Text(property.title ?? "")
                    .font(.Roboto.Regular(of: 16))
                    .foregroundColor(Color.black)
                    .padding([.leading, .trailing], 8)
                    .lineLimit(2)
                    .frame(maxHeight: 50)
                    .padding(.top, 16)
                
                addressView
                    .padding(.top, 9)
            }
            .padding(.horizontal, 9)
            .padding(.bottom, 15.86)
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 7, x: 0, y: 4)
            
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hex: 0xF4F4F4), lineWidth: 1.5)
            
        }
        .padding(1)
    }
    
    var imageAndHeartView: some View {
        ZStack(alignment: .topTrailing) {
            KFImage(URL(string: Config.imageBaseUrl + (property.images?.first?.image ?? "")))
                .placeholder { Image("default_property").resizable()
                    .frame(height: 130).cornerRadius(15) }
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .cornerRadius(15, corners: [.topLeft, .topRight])
            
            
            Button {
                favouriteAction?()
            } label: {
                Image(property.isFavorite ?? false ? "whish_filled" : "wish")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.top, 8)
                    .padding(.trailing, 8)
            }
        }
    }
    
    var priceView: some View {
        HStack(spacing: 0) {
            Text(String(format: "%.0f", property.price ?? 0.0))
                .font(.Roboto.Medium(of: 18))
                .foregroundColor(Color.black)
            
            Text("AED")
                .font(.Roboto.Regular(of: 18))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
        }
        .frame(height: 17)
        .padding(.top, 16)
    }
    
    var addressView: some View {
        HStack(spacing: 0) {
            Image("location_pin")
            
            Text(property.neighbourhood ?? "")
                .font(.roboto_14())
                .foregroundStyle(.black.opacity(0.5))
                .padding(.leading, 8)
        }
        .frame(height: 17)
    }
}
//#Preview {
//    PropertyListScreenView()
//}
