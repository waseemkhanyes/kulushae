//
//  CarsSearchResultView.swift
//  Kulushae
//
//  Created by ios on 29/03/2024.
//

import SwiftUI

struct CarsSearchResultView: View {
    @StateObject var dataHandler = HomeViewModel.ViewModel()
    @State private var items: [String] = []
    @State var isSelectedId: Int = 0
    @State var pageNumber: Int = 1
    @State private var isDetailViewActive = false
    @State var user_id: Int?
    @State var searchKey: String = ""
    @EnvironmentObject var languageManager: LanguageManager
    @State var isOpenFilterView: Bool = false
    @State var argsDictionary: [String: String?] = [:]
    @State var selectedCatId: String
    @StateObject var favDataHandler = ProductDetailsViewModel.ViewModel()
    @State var totalNumber = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        UILoader(isShowing: dataHandler.isCarLoading) {
            if(dataHandler.carObject.isEmpty &&  !dataHandler.isCarLoading ) {
                NoItemFoundView(isShowBackButton: true)
            } else {
                ZStack(alignment: .bottom) {
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
                                dismiss()
                                
                            }
                            HStack(spacing: 10) {
                                Text(LocalizedStringKey("Result Found"))
                                    .font(.roboto_22_semi())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .foregroundColor(Color.black)
                                    .padding(.leading, 10)
                                //                            if(dataHandler.totaladCount > 0) {
                                Text(String(dataHandler.totaladCount))
                                    .font(.roboto_22_semi())
                                    .foregroundColor(Color.black)
                                //                            }
                            }
                            Spacer()
                            Image(uiImage: UIImage(named: "icn_filter") ?? UIImage())
                                .frame(width: 55, height: 55)
                                .onTapGesture {
                                    isOpenFilterView = true
                                }
                                .padding(.trailing, 15)
                        }
                        .padding(.top, 70)
                        ScrollViewReader { scrollViewProxy in
                            ScrollView {
                                LazyVStack(spacing: 20) {
                                    ForEach(Array(dataHandler.carObject.enumerated()), id: \.element.id) { index, motor in
                                        VStack(alignment: .leading, spacing : 10) {
                                            
                                            AsyncImage(url: URL(string: (Config.imageBaseUrl) + (dataHandler.carObject[index].images?.first?.image ?? ""))) { image in
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
                                                    Text(String(format: "%.0f", motor.price ?? 0.0))
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
                                                .padding(.horizontal, 8)
                                                
                                                //                                            if(dataHandler.carObject[index].isFeatured ?? false) {
                                                //                                                Spacer()
                                                //                                                Text("Featured")
                                                //                                                    .padding(12)
                                                //                                                    .font(.roboto_18_bold())
                                                //                                                    .font(.headline.weight(.semibold))
                                                //                                                    .multilineTextAlignment(.leading)
                                                //                                                    .foregroundColor(.white)
                                                //                                                    .background(Color.appPrimaryColor)
                                                //                                                    .cornerRadius(15)
                                                //                                            }
                                            }
                                            HStack(spacing: 5){
                                                Image("location_pin")
                                                    .padding(.leading, 8)
                                                Text(LocalizedStringKey(motor.emirates ?? ""))
                                                    .font(.roboto_14())
                                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                                    .font(.headline.weight(.semibold))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundColor(Color.gray)
                                                Spacer()
                                            }
                                            Text(motor.title ?? "")
                                                .padding(.horizontal, 8)
                                                .font(.roboto_20())
                                                .font(.headline.weight(.thin))
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(Color.black)
                                            HStack(alignment: .center) {
                                                Spacer()
                                                if(!(motor.year ?? "").isEmpty) {
                                                    MotorAditionalDataView(title: "Year", value: motor.year ?? "")
                                                }
                                                if(!(motor.kilometers ?? "").isEmpty) {
                                                    MotorAditionalDataView(title: "KILOMETER", value: motor.kilometers ?? "")
                                                }
                                                if(!(motor.specs ?? "").isEmpty) {
                                                    MotorAditionalDataView(title: "SPECS", value: motor.specs ?? "")
                                                }
                                                if(!(motor.steeringSide ?? "").isEmpty) {
                                                    MotorAditionalDataView(title: "Steering", value: motor.steeringSide ?? "")
                                                }
                                                Spacer()
                                            }
                                            
                                            Spacer()
                                        }
                                        .overlay() {
                                            HStack(spacing: 20) {
                                                Spacer()
                                                Button {
                                                    let type = dataHandler.carObject[index].type ?? ""
                                                    if(dataHandler.carObject[index].isFavorite ?? false) {
                                                        dataHandler.carObject[index].isFavorite = false
                                                        addFavourite(productId: dataHandler.carObject[index].id ?? 0, isLike: false, index: index, type: type)
                                                    } else {
                                                        dataHandler.carObject[index].isFavorite = true
                                                        addFavourite(productId: dataHandler.carObject[index].id ?? 0, isLike: true, index: index, type: type)
                                                    }
                                                    
                                                } label: {
                                                    Image((dataHandler.carObject[index].isFavorite ?? false) ? "whish_filled" :  "wish")
                                                        .padding()
                                                }
                                                .frame(width: 30, height: 30)
                                                .zIndex(2.0)
                                            }
                                            .padding(.trailing, 15)
                                            .offset(y: -140)
                                        }
                                        .onAppear {
                                            // Detect when the last item is about to appear
                                            if itemIsLast(item: motor) {
                                                if(dataHandler.totalPageCount >= pageNumber) {
                                                    loadMoreData()
                                                }
                                                
                                                // Scroll to the new bottom item
                                                withAnimation {
                                                    scrollViewProxy.scrollTo(items.last, anchor: .bottom)
                                                }
                                            }
                                        }
                                        .background(.white)
                                        .onTapGesture() {
                                            isSelectedId = motor.id ?? -1
                                            isDetailViewActive = true
                                        }
                                        .frame( height: 325)
                                        .background(.white)
                                        .cornerRadius(15)
                                        .shadow(color: .black.opacity(0.05), radius: 7, x: 0, y: 4)
                                    }
                                    
                                    if dataHandler.isCarLoading {
                                        ProgressView()
                                            .frame(height: 40)
                                    }
                                }
                                .padding()
                                Spacer()
                                //                                .frame(height: 170)
                            }
                        }
                        Spacer()
                    }
                    BottomSheetView(isOpen: $isOpenFilterView,
                                    maxHeight: .screenHeight * 0.8) {
                        MotorFilterView( argsDictionary: $argsDictionary, isOpen: $isOpenFilterView, catId: Int(selectedCatId) ?? 0)
                        
                    }.edgesIgnoringSafeArea(.all)
                        .frame(width: .screenWidth,
                               height: isOpenFilterView ? .screenHeight  : 0.0,
                               alignment: .bottom)
                        .opacity(isOpenFilterView ? 1.0 : 0.0)
                }
            }
        }
        .onAppear {
            dataHandler.isCarLoading = true
            loadMoreData()
           
        }
        .onChange(of: searchKey) { newKey in
            if(!(searchKey == "")) {
                dataHandler.carObject = []
                pageNumber = 1
                argsDictionary["keyword"] = newKey
            }
            print("od", Int(selectedCatId))
            dataHandler.getPostedMotorList(request: HomeViewModel.GetCarRequest.Request(page: pageNumber,userId: self.user_id, isPagination: true, catId: Int(selectedCatId), filterArray: argsDictionary))
            pageNumber+=1
        }
        .onChange(of: isOpenFilterView) { newIsOpenFilterView in
            if !newIsOpenFilterView {
                pageNumber = 1
                dataHandler.carObject = []
                //                if let jsonString = convertToJSONString(argsDictionary ?? [:]) {
                //                    print("filter json", jsonString)
                ////                        testString = jsonString
                //                }
                loadMoreData()
            }
        }
        .navigationBarBackButtonHidden(true)
        
        if(isSelectedId != -1 && !$dataHandler.carObject.isEmpty) {
            NavigationLink("", destination: CarDetailsView(motorId: isSelectedId) ,
                           isActive: $isDetailViewActive)
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    func addFavourite(productId: Int, isLike: Bool, index: Int, type: String) {
        favDataHandler.addFavDetails(request: ProductDetailsViewModel.AddFavourite.Request(like: isLike, itemId: productId, type: type))
        //        dataHandler.carObject[index].isFavorite  = !(dataHandler.carObject[index].isFavorite ?? false)
    }
    
    func itemIsLast(item: PostedCars) -> Bool {
        return item == dataHandler.carObject.last
    }
    
    private func loadMoreData() {
//        guard !dataHandler.isCarLoading else { return }
        //
        
        argsDictionary["keyword"] = searchKey
        if let jsonString = convertToJSONString(argsDictionary ?? [:]) {
            print("filter json", jsonString, searchKey)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dataHandler.getPostedMotorList(request: HomeViewModel.GetCarRequest.Request(page: pageNumber,userId: self.user_id, isPagination: true, catId: Int(selectedCatId), filterArray: argsDictionary))
            pageNumber+=1
        }
    }
}
