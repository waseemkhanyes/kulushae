//
//  AdsView.swift
//  Kulushae
//
//  Created by ios on 20/10/2023.
//

import SwiftUI
import Kingfisher

struct AdsModel: Codable, Hashable {
    let id: Int
    let title: String
    let subTitle: String
    let info: String
    let image: String
}

struct AdsView: View {
    @StateObject var locationViewModel: LocationViewModel =  LocationViewModel()
    //    @State var isCityChosen = false
    //    @State  var selectedCityId:Int  =  -1
    @State var selectedCityName:String  = ""
    @EnvironmentObject var languageManager: LanguageManager
    @State var selectedCategory: String  = ""
    @State var selectedId: Int?
    @State private var isNavigationActive = false
    @StateObject var dataHandler = HomeViewModel.ViewModel()
    let goHome: () -> Void
    @State var isOpenDetails: Bool = false
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @State var isPresentSelectLocation = false
    @State var parentCategoryId = -3
    
    var strLang: String {
        UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    }
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    
                    topView
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            topDetailView
                            
                            categoriesView
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .background(Color.appBackgroundColor)
                //                .blur(radius: isCityChosen ? 2 : 0)
                .onAppear {
                    self.loadCacheOFSelectedLocationFromUserDefaults()
                    //                    dataHandler.getCountryList()
                    dataHandler.getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(afl: 1))
                    //                    if let cityId: Int = UserDefaultManager.get(.choseCityId),
                    //                       let name: String = UserDefaultManager.get(.choseCityName) {
                    //                        self.selectedCityId = cityId
                    //                        self.selectedCityName = name
                    //                        self.isCityChosen = false
                    //                    } else {
                    //                        self.isCityChosen = true
                    //                    }
                }
                
                //                BottomSheetView(isOpen: $isCityChosen,
                //                                maxHeight: 350) {
                //                    CityView(isOpen: $isCityChosen, city: dataHandler.countryList, selectedCityName: $selectedCityName, selectedCityId: $selectedCityId )
                //
                //                }
                //                .edgesIgnoringSafeArea(.all)
                //                .frame(width: .screenWidth, height: isCityChosen ? .screenHeight  : 0.0, alignment: .bottom)
                //                .opacity(isCityChosen ? 1.0 : 0.0)
            }
            //            .cleanNavigation()
            
            NavigationLink("", destination: PropertyView( catId: .constant(selectedId ?? -1), serviceType: .Property, titleVal: selectedCategory), isActive: $isNavigationActive)
                .navigationBarBackButtonHidden(true)
//            NavigationLink("", destination: AdDetailsView(openedStates: [],  newCatIdVal: selectedId ?? -1,  titleVal: selectedCategory, stepNum: 1), isActive: $isOpenDetails)
            NavigationLink("", destination: CreateAdsFormView(dataHandler: .init(title: selectedCategory, newCatIdVal: selectedId ?? -1, stepNum: 1, parentCatIdVal: parentCategoryId, serviceType: .Motor)), isActive: $isOpenDetails)
            
        }
        .popUpBack(show: isPresentSelectLocation)
        .fullScreenCover(isPresented: $isPresentSelectLocation) {
            SelectLocationPopupView(viewModel: .init(type: .ForAddPost, handler: {
                self.isPresentSelectLocation = false
                self.loadCacheOFSelectedLocationFromUserDefaults()
            }))
            .clearBackground()
        }
    }
    
    func loadCacheOFSelectedLocationFromUserDefaults() {
        guard let selected = PersistenceManager.shared.countryDataForAddPost else {
            isPresentSelectLocation = true
            return
        }
        
        let stateModel = selected.arrayState.filter({ $0.id == selected.selectedStateID }).first
        let stateName = strLang == "en" ? trim(stateModel?.name) : trim(stateModel?.translation)
        let countryName = strLang == "en" ? trim(selected.country.iso3) : trim(selected.country.translation)
        selectedCityName = [stateName, countryName].joined(separator: ", ")
        //        strSelectedLocation = [stateName, countryName].joined(separator: ", ")
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            Button(action: goHome) {
                VStack(spacing: 0) {
                    Image("back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 12, alignment: .center)
                        .clipped()
                        .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                }
                .frame(width: 35, height: 35)
            }
            .padding(.leading, 12)
            
            Text(LocalizedStringKey("Select Category"))
                .font(.Roboto.Medium(of: 22))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.leading, 5)
            
        }
        .frame(height: 50)
        .padding(.top, safeAreaInsets.top)
    }
    
    var topDetailView: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(LocalizedStringKey("Hello, what are you listing today?"))
                .font(.Roboto.Bold(of: 24))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(LocalizedStringKey("Ad will be displayed on your default location "))
                .font(.Roboto.Regular(of: 14))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.top, 16)
            
            Text(LocalizedStringKey("Change Location"))
                .font(.Roboto.Regular(of: 14))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .frame(height: 30)
            
            
            Button(action: {
                isPresentSelectLocation = true
                //                isCityChosen = true
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(self.selectedCityName)
                        .foregroundColor(Color.black)
                        .font(.roboto_16_bold())
                        .fontWeight(.bold)
                        .environment(\.locale, .init(identifier: "en"))
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1.0)
                }
                .padding(1)
            }
            .padding(.bottom, 20)
            
        }
        .frame(maxWidth: .infinity)
    }
    
    var categoriesView: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(dataHandler.availableForAddPost.chunked(into: 4), id: \.self) { chunk in
                HStack(spacing: 15) {
                    ForEach(chunk, id: \.self) { category in
                        categoryItemView(category)
                    }
                }
            }
        }
    }
    
    func categoryItemView(_ category: CategoryListModel) -> some View {
        Button(action: {
            print("** wk categoryId: \(category.id)")
            selectedId = Int(category.id)
            selectedCategory = category.title ?? ""
            
            if(category.has_form) {
//                AdDetailsView.parentCatIdVal = Int(category.id) ?? -3
                parentCategoryId = Int(category.id) ?? -3
                if(category.has_child ?? false) {
                    isNavigationActive = true
                } else {
                    isOpenDetails = true
                }
            } else {
                isNavigationActive = true
            }
            
            
            //            if PersistenceManager.shared.countryDataForAddPost == nil {
            //                isPresentSelectLocation = true
            //            }
            //            let cityId: Int = UserDefaultManager.get(.choseCityId) ?? -1
            //            if( cityId > 0 || (selectedId ?? -1) > 0)  {
            //                selectedId = Int(category.id)
            //                selectedCategory = category.title ?? ""
            //                //                                            print(selectedId, category.has_form)
            //                if(category.has_form) {
            //                    AdDetailsView.parentCatIdVal = Int(category.id) ?? -3
            //                    if(category.has_child ?? false) {
            //                        isNavigationActive = true
            //                    } else {
            //                        isOpenDetails = true
            //                    }
            //                } else {
            //                    isNavigationActive = true
            //                }
            //            } else {
            //                self.isCityChosen = true
            //            }
        }) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    KFImage(URL(string: Config.imageBaseUrl + (category.image ?? "")))
                        .placeholder {
                            Image("default_property")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: (.screenWidth / 4 ) - 15 , height: (.screenWidth / 4 ) - 15)
                                .cornerRadius(15, corners: [.topLeft, .topRight])
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                }
                .frame(width: (.screenWidth / 4 ) - 15 , height: (.screenWidth / 4 ) - 15)
                .background(Color.backgroundCategoryColor)
                .cornerRadius(25)
                
                
                Text(LocalizedStringKey(category.title ?? ""))
                    .font(.roboto_14_Medium())
                    .fontWeight(.medium)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
                    .frame(width: (.screenWidth / 4 ) - 15, height: 35)
            }
        }
    }
}
