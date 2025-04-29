//
//  MotorMakesListView.swift
//  Kulushae
//
//  Created by Waseem  on 12/11/2024.
//

import SwiftUI
import Kingfisher

struct MotorMakesListView: View {
    @StateObject var dataHandler: MotorMakesListModel.ViewModel
    
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            VStack(spacing: 0) {
                if dataHandler.arrayMotorMakes.isEmpty && dataHandler.isShowEmptyMessage {
                    NoItemFoundView(isShowBackButton: false)
                } else {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            topView
                            
                            searchAndFilterView
                                .padding(.horizontal, 18)
                        }
                        .padding(.bottom, 10)
                        .background(.white)
                        .shadowColor(show: dataHandler.scrollOffset > 0.0)
                        
                        BrandsListingView(arrayMakes: dataHandler.arrayMotorMakes, scrollOffset: $dataHandler.scrollOffset, action: dataHandler.onClickItemActions)
                        
                        VStack(spacing: 0) {}
                            .background(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: safeAreaInsets.bottom)
                    }
                }
            }
            .cleanNavigation()
            .background(
                navigationLinks
            )
        }
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            Button(action: {
                dismiss()
            }) {
                VStack(spacing: 0) {
                    Image(.back)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 15, alignment: .center)
                        .clipped()
                        .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                        .padding(.leading, 20)
                }
            }
            
            Text(LocalizedStringKey("All Brands"))
                .font(.roboto_22_semi())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.leading, 10)
            
            Spacer()
        }
        .frame(height: 50)
        .padding(.top, safeAreaInsets.top)
    }
    
    var filterButtonView: some View {
        Button(action: {}) {
            VStack(spacing: 0) {
                Image(.filter)
                    .resizable()
                    .frame(width: 19.13, height: 16.75)
            }
            .frame(width: 45, height: 45)
            .background {
                RoundedRectangle(cornerRadius: 22.5)
                    .stroke(Color(hex: "#F0F0F0"), lineWidth: 1)
            }
        }
    }
    
    var searchView: some View {
        VStack(spacing: 0) {
            TextField(LocalizedStringKey("Search"), text: $dataHandler.searchText)
                
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding(.horizontal, 18)
                .font(.roboto_16())
                .frame(height: 45)
                
        }
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 22.5)
                .stroke(Color(hex: "#F0F0F0"), lineWidth: 1)
        }
    }
    
    var searchAndFilterView: some View {
        HStack(spacing: 13) {
            searchView
            
//            filterButtonView
        }
    }
    
    private var navigationLinks: some View {
        Group {
            if let selectedMotor = dataHandler.selectedMotor {
                NavigationLink(
                    "",
                    destination: MotorMakeSingleView(
                        dataHandler: .init(
                            category: dataHandler.selectedCategory,
                            motorMake: selectedMotor
                        )
                    ),
                    isActive: $dataHandler.isPresentMotorMakeSingleView
                )
            }
        }
    }
}

fileprivate struct BrandsListingView: View {
    var arrayMakes: [MotorMake]
    @Binding var scrollOffset: CGFloat
    @EnvironmentObject var languageManager: LanguageManager
    var action: ((Bool, MotorMake)->())? = nil
    
    var body: some View {
        ObservableScrollView(showsIndicators: false, scrollOffset: $scrollOffset) { _ in
            LazyVStack {
                // Loop through items in chunks of 3
                ForEach(0..<arrayMakes.count / 3 + (arrayMakes.count % 3 == 0 ? 0 : 1), id: \.self) { rowIndex in
                    HStack(spacing: 20) {
                        ForEach(0..<3) { columnIndex in
                            let itemIndex = rowIndex * 3 + columnIndex
                            if itemIndex < arrayMakes.count {
                                let item = arrayMakes[itemIndex]
                                VStack(spacing: 0) {
                                    KFImage(URL(string: (Config.imageBaseUrl) + (item.image)))
                                        .placeholder {
                                            Image("default_property")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 62)
                                                .cornerRadius(15, corners: [.topLeft, .topRight])
                                                .clipped()
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .padding(.top, 15)
                                    
                                    
                                    Spacer()
                                    
                                    Text(item.title)
                                        .font(.roboto_14())
                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 3)
                                        .padding(.bottom, 10)
                                }
                                .frame(height: 109)
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(hex: "#cccccc"), lineWidth: 1)
                                }
                                .onAppear {
                                    if itemIndex == arrayMakes.count - 1 {
                                        action?(true, item)
                                    }
                                }
                                .onTapGesture {
                                    action?(false, item)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 3), spacing: 15) {
//                ForEach(Array(arrayMakes.enumerated()), id: \.element.id) { itemIndex, item in
//                    VStack(spacing: 0) {
//                        KFImage(URL(string: (Config.imageBaseUrl) + (item.image)))
//                            .placeholder {
//                                Image("default_property")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 100, height: 62)
//                                    .cornerRadius(15, corners: [.topLeft, .topRight])
//                                    .clipped()
//                            }
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 60, height: 60)
//                            .padding(.top, 15)
//                        
//                        
//                        Spacer()
//                        
//                        Text(item.title)
//                            .font(.roboto_14())
//                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color.black)
//                            .frame(maxWidth: .infinity)
//                            .padding(.horizontal, 3)
//                            .padding(.bottom, 10)
//                    }
//                    .frame(height: 109)
//                    .frame(maxWidth: .infinity)
//                    .background {
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color(hex: "#cccccc"), lineWidth: 1)
//                    }
//                    .onAppear {
//                        if itemIndex == arrayMakes.count - 1 {
//                            action?(true, item)
//                        }
//                    }
//                    .onTapGesture {
//                        action?(false, item)
//                    }
//                }
//            }
//            .padding(0.5)
//            .padding(.horizontal, 18)
        }
        .frame(maxHeight: .infinity)
    }
}

//#Preview {
//    MotorMakesListView()
//}
