//
//  CarListScreenView.swift
//  Kulushae
//
//  Created by Waseem  on 27/11/2024.
//

import SwiftUI
import Kingfisher

struct CarListScreenView: View {
    @StateObject var dataHandler: CarListViewModel.ViewModel
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @StateObject var favDataHandler = ProductDetailsViewModel.ViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        UILoader(isShowing: dataHandler.isCarLoading) {
            if(dataHandler.carObject.isEmpty &&  !dataHandler.isCarLoading ) {
                NoItemFoundView(isShowBackButton: true)
            } else {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        
                        topView
                        
                        ObservableScrollView(showsIndicators: false, scrollOffset: $dataHandler.scrollOffset) { _ in
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 2), spacing: 15) {
                                ForEach(Array(dataHandler.carObject.enumerated()), id: \.element.id) { index, car in
                                    MotorMakeCardView(car: car) {
                                        let type = dataHandler.carObject[index].type ?? ""
                                        if(dataHandler.carObject[index].isFavorite ?? false) {
                                            dataHandler.carObject[index].isFavorite = false
                                            addFavourite(productId: dataHandler.carObject[index].id ?? 0, isLike: false, index: index, type: type)
                                        } else {
                                            dataHandler.carObject[index].isFavorite = true
                                            addFavourite(productId: dataHandler.carObject[index].id ?? 0, isLike: true, index: index, type: type)
                                        }
                                    }
                                    .onTapGesture {
                                        dataHandler.onClickCar(car)
                                    }
                                    .onAppear {
                                        if index == dataHandler.carObject.count - 1 {
                                            dataHandler.loadMoreData()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 18)
                        }
                    }
                    
//                    BottomSheetView(isOpen: $dataHandler.isOpenFilterView,
//                                    maxHeight: .screenHeight * 0.8) {
//                        MotorFilterView( argsDictionary: $dataHandler.argsDictionary, isOpen: $dataHandler.isOpenFilterView, catId: dataHandler.detailCarId)
//                        
//                    }.edgesIgnoringSafeArea(.all)
//                        .frame(width: .screenWidth,
//                               height: dataHandler.isOpenFilterView ? .screenHeight  : 0.0,
//                               alignment: .bottom)
//                        .opacity(dataHandler.isOpenFilterView ? 1.0 : 0.0)
                }
            }
        }
        .cleanNavigationAndSafeArea()
        .sheet(isPresented: $dataHandler.isPresentFilterSheet) {
            MotorCategoryFilterView(viewModel: .init(arrayFilters: dataHandler.arrayFilters, handler: { data in
                dataHandler.isPresentFilterSheet = false
                if let data {
                    dataHandler.arrayFilters = data
                    dataHandler.checkCacheCarList()
                }
            }))
        }
//        .sheet(isPresented: $dataHandler.isPresentFilterSheet) {
//            MotorCategoryFilterView(viewModel: .init(handler: { data in
//                dataHandler.isPresentFilterSheet = false
//                if let data {
//                    dataHandler.arrayFilters = data
//                }
//            }))
//        }
        
        if(dataHandler.detailCarId != -1 && !$dataHandler.carObject.isEmpty) {
            NavigationLink("", destination: CarDetailsView(motorId: dataHandler.detailCarId) ,
                           isActive: $dataHandler.isCarDetailView)
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            ZStack {
                Image("back")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 15, alignment: .center)
                    .clipped()
                    .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
            }
            .frame(width: 35, height: 35)
            .onTapGesture {
                dismiss()
            }
            
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
//                dataHandler.isOpenFilterView = true
                dataHandler.isPresentFilterSheet = true
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
    
    func addFavourite(productId: Int, isLike: Bool, index: Int, type: String) {
        favDataHandler.addFavDetails(request: ProductDetailsViewModel.AddFavourite.Request(like: isLike, itemId: productId, type: type))
    }
    
    func itemIsLast(item: PostedCars) -> Bool {
        return item == dataHandler.carObject.last
    }
}

fileprivate struct MotorMakeCardView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    var car: PostedCars
    var favouriteAction: (()->())? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageAndHeartView
            
            VStack(alignment: .leading, spacing: 0) {
                priceView
                
                Text(car.title ?? "")
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
            KFImage(URL(string: Config.imageBaseUrl + (car.images?.first?.image ?? "")))
                .placeholder { Image("default_property").resizable()
                    .frame(height: 130).cornerRadius(15) }
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .cornerRadius(15, corners: [.topLeft, .topRight])
            
            
            Button {
                favouriteAction?()
            } label: {
                Image(car.isFavorite ?? false ? "whish_filled" : "wish")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.top, 8)
                    .padding(.trailing, 8)
            }
        }
    }
    
    var priceView: some View {
        HStack(spacing: 0) {
            Text(String(format: "%.0f", car.price ?? 0.0))
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
            
            Text(car.emirates ?? "")
                .font(.roboto_14())
                .foregroundStyle(.black.opacity(0.5))
                .padding(.leading, 8)
        }
        .frame(height: 17)
    }
}
