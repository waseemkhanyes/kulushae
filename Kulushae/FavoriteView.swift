//
//  FavoriteView.swift
//  Kulushae
//
//  Created by ios on 27/11/2023.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject var dataHandler = FavouriteViewModel.ViewModel()
    @StateObject var favDataHandler = ProductDetailsViewModel.ViewModel()
    @State private var items: [String] = []
    @State var isSelectedId: Int = 0
    @State var pageNumber: Int = 1
    @State private var isDetailViewActive = false
    @State private var isCarDetailViewActive = false
    @State var user_id: Int = -1
    @State var searchKey: String = ""
    @EnvironmentObject var languageManager: LanguageManager
    @State var isOpenFilterView: Bool = false
    @State var argsDictionary: [String: String?] = [:]
    let goHome: () -> Void
    @State private var isShowEmptyMessage = false
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack(alignment: .bottom) {
             
                if dataHandler.advObject.isEmpty && isShowEmptyMessage {
                    NoItemFoundView(isShowBackButton: false)
                } else {
                    VStack(alignment: .leading) {
                        HStack {
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
                                goHome()
                                
                            }
                            Text(LocalizedStringKey("Favourite"))
                                .font(.roboto_22_semi())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor(Color.black)
                                .padding(.leading, 10)
                            Spacer()
                        }
                        .padding(.top, 80)
                        ScrollViewReader { scrollViewProxy in
                            ScrollView {
                                    LazyVStack(spacing: 20) {
                                        ForEach(Array(dataHandler.advObject.enumerated()), id: \.element.id) { index, property in
                                            VStack(alignment: .leading, spacing : 10) {
                                                
                                                AsyncImage(url: URL(string: (Config.imageBaseUrl) + (dataHandler.advObject[index].image ?? ""))) { image in
                                                    image
                                                        .resizable()
                                                        .frame(width: .screenWidth * 0.9,  height: 165)
                                                        .scaledToFill()
                                                        .cornerRadius(15)
                                                        .padding(.top, 5)
                                                } placeholder: {
                                                    Image("default_property")
                                                        .resizable()
                                                        .frame( height: 125)
                                                        .cornerRadius(15)
                                                        .padding(.top, 5)
                                                }
                                                
                                                HStack {
                                                    HStack(spacing: 5) {
                                                        Text(String(property.price ?? "0"))
                                                            .font(.roboto_20())
                                                            .font(.headline.weight(.semibold))
                                                            .multilineTextAlignment(.leading)
                                                            .foregroundColor(Color.black)
                                                        Text(LocalizedStringKey("AED"))
                                                                                                    .font(.roboto_20())
                                                                                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                                                                                    .font(.headline.weight(.semibold))
                                                                                                    .multilineTextAlignment(.leading)
                                                                                                    .foregroundColor(Color.black)
                                                    }
                                                   
                                                    //                                                .padding(.vertical)
//                                                    if(dataHandler.advObject[index].isFeatured ?? false) {
//                                                        Spacer()
//                                                        Text("Featured")
//                                                            .padding(12)
//                                                            .font(.roboto_18_bold())
//                                                            .font(.headline.weight(.semibold))
//                                                            .multilineTextAlignment(.leading)
//                                                            .foregroundColor(.white)
//                                                            .background(Color.appPrimaryColor)
//                                                            .cornerRadius(15)
//                                                    }
                                                }
                                                HStack(spacing: 5){
                                                    Image("location_pin")
                                                        .padding(.leading, 8)
                                                    Text(property.location ?? "")
                                                        .font(.roboto_14())
                                                        .font(.headline.weight(.semibold))
                                                        .multilineTextAlignment(.leading)
                                                        .foregroundColor(Color.gray)
                                                    Spacer()
                                                }
                                                Text(property.title ?? "")
                                                    .padding(.horizontal, 8)
                                                    .font(.roboto_20())
                                                    .font(.headline.weight(.thin))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundColor(Color.black)
                                                //                                            .padding(.vertical)
                                                HStack {
                                                    if(!(property.bedrooms ?? "").isEmpty) {
                                                        ImageLeftTextRightView(text: property.bedrooms ?? "", image: "bedroom")
                                                    }
                                                    if(!(property.bathrooms ?? "").isEmpty) {
                                                        ImageLeftTextRightView(text: property.bathrooms ?? "", image: "bathroom")
                                                    }
                                                    if(!(property.size ?? "").isEmpty) {
                                                        ImageLeftTextRightView(text: property.size ?? "", image: "sqrft")
                                                    }
                                                    if(!(property.carYear ?? "").isEmpty) {
                                                        ImageLeftTextRightView(text: property.carYear ?? "", image: "icn_car")
                                                    }
                                                    if(!(property.carKilometers ?? "").isEmpty) {
                                                        ImageLeftTextRightView(text: property.carKilometers ?? "", image: "icn_kilometer")
                                                    }
                                                    if(!(property.carSpecs ?? "").isEmpty) {
                                                        ImageLeftTextRightView(text: property.carSpecs ?? "", image: "icn_spec")
                                                    }
                                                    if(!(property.carSteering ?? "").isEmpty) {
                                                        ImageLeftTextRightView(text: property.carSteering ?? "", image: "icn_steering")
                                                    }
                                                }
                                                
                                                
                                                Spacer()
                                            }
//                                            .overlay() {
//                                                HStack(spacing: 20) {
//                                                    Spacer()
//                                                    Button {
//                                                        if(dataHandler.advObject[index].isFavorite ?? false) {
//                                                            dataHandler.advObject[index].isFavorite = false
//                                                            addFavourite(productId: dataHandler.advObject[index].id ?? 0, isLike: false, index: index)
//                                                        } else {
//                                                            dataHandler.advObject[index].isFavorite = true
//                                                            addFavourite(productId: dataHandler.advObject[index].id ?? 0, isLike: true, index: index)
//                                                        }
//                                                        
//                                                    } label: {
//                                                        Image(systemName: "heart.fill")
//                                                            .foregroundColor(.white)
//                                                            .frame(width: 24, height: 24)
//                                                            .padding(8)
//                                                            .background(Color.black.opacity(0.5))
//                                                            .cornerRadius(12)
//                                                    }
//                                                }
//                                                .padding(.trailing, 20)
//                                                .offset(y: -120)
//                                            }
                                            .onAppear {
                                                if itemIsLast(item: property) {
                                                    if(dataHandler.totalPageCount >= pageNumber) {
                                                        loadMoreData()
                                                    }
                                                    withAnimation {
                                                        scrollViewProxy.scrollTo(items.last, anchor: .bottom)
                                                    }
                                                }
                                            }
                                            .background(.white)
                                            .onTapGesture() {
                                                isSelectedId = property.id ?? -1
                                                if let type = property.type,
                                                   type.lowercased().contains("motor") {
                                                    isCarDetailViewActive = true
                                                    isDetailViewActive = false
                                                } else {
                                                    isDetailViewActive = true
                                                    isCarDetailViewActive = false
                                                }
                                            }
                                            .frame( height: 325)
                                            .background(.white)
                                            .cornerRadius(15)
                                            .shadow(color: .black.opacity(0.05), radius: 7, x: 0, y: 4)
                                        }
                                        
                                        if dataHandler.isLoading {
                                            ProgressView()
                                                .frame(height: 40)
                                        }
                                    }
                                    .padding()
                                
                                
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .background(isOpenFilterView ? Color.unselectedTextBackgroundColor : .white)
                }
            }
        }
        .onAppear {
            user_id = Int(PersistenceManager.shared.loggedUser?.id ?? "-1") ?? -1
            loadMoreData()
        }
        
        .navigationBarBackButtonHidden(true)
        if(isSelectedId != -1 && !$dataHandler.advObject.isEmpty) {
            NavigationLink("", destination: PostedAdDetailsView(productId: isSelectedId) ,
                           isActive: $isDetailViewActive)
            .navigationBarBackButtonHidden(true)
            
            NavigationLink("", destination: CarDetailsView(motorId: isSelectedId) ,
                           isActive: $isCarDetailViewActive)
        }
        
        
    }
    
    func itemIsLast(item: FavouriteModel) -> Bool {
        return item == dataHandler.advObject.last
    }
    
    private func loadMoreData() {
        dataHandler.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dataHandler.fetchFavAdvList(request: FavouriteViewModel.GetFavRequest.Request(page: pageNumber, userId: user_id))
            dataHandler.isLoading = false
            pageNumber+=1
            if(dataHandler.advObject.isEmpty) {
                isShowEmptyMessage = true
            }
        }
    }
    
    func addFavourite(productId: Int, isLike: Bool, index: Int, type: String) {
        favDataHandler.addFavDetails(request: ProductDetailsViewModel.AddFavourite.Request(like: false, itemId: productId, type: type))
        dataHandler.advObject.remove(at: index)
    }
}

//#Preview {
//    FavoriteView()
//}
