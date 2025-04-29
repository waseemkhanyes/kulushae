//
//  SearchResultView.swift
//  Kulushae
//
//  Created by ios on 23/11/2023.
//

import SwiftUI
import Kingfisher
import MapKit

struct SearchResultView: View {
    @StateObject var dataHandler = HomeViewModel.ViewModel()
    @State private var items: [String] = []
    @State var isSelectedId: Int = 0
    @State var pageNumber: Int = 1
    @State private var isDetailViewActive = false
    @State var user_id: Int?
    @State var searchKey: String = ""
    @State var searchLocationArray: [String] = []
    @State private var searchResults: [MKMapItem] = []
    @EnvironmentObject var languageManager: LanguageManager
    @State var isOpenFilterView: Bool = false
    @State var isOpenLocSearchView: Bool = false
    @State var argsDictionary: [String: String?] = [:]
    @State var selectedCatId: String
    @StateObject var favDataHandler = ProductDetailsViewModel.ViewModel()
    @State var totalNumber = ""
    @Environment(\.dismiss) var dismiss
    
    // Define a grid layout with 2 columns
    let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            if dataHandler.advObject.isEmpty && !dataHandler.isLoading {
                NoItemFoundView(isShowBackButton: true)
            } else {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        SearchResultNavigationBar(totalCount: dataHandler.totaladCount) {
                            dismiss()
                        }
//                        TagCarousel(items: ["Item 1","Item 2"])
                        SearchFilterControls(isOpenLocSearchView: $isOpenLocSearchView, isOpenFilterView: $isOpenFilterView, searchLocationArray: searchLocationArray)
                        PropertyGridView(properties: dataHandler.advObject, gridColumns: gridColumns, isSelectedId: $isSelectedId, isDetailViewActive: $isDetailViewActive, onLastItem: loadMoreData)
                    }
                    .sheet(isPresented: $isOpenLocSearchView) {
                        SearchWithLocationView(isOpen: $isOpenLocSearchView, selectedLocationArray: $searchLocationArray, title: "Search by Location")
                    }
                    BottomSheetView(isOpen: $isOpenFilterView, maxHeight: .screenHeight * 0.8) {
                        PropertyFilterView(argsDictionary: $argsDictionary, isOpen: $isOpenFilterView, catId: Int(selectedCatId) ?? 0)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: .screenWidth, height: isOpenFilterView ? .screenHeight : 0, alignment: .bottom)
                    .opacity(isOpenFilterView ? 1.0 : 0.0)
                }
            }
        }
        .onAppear {
            dataHandler.isLoading = true
            loadMoreData()
        }
        .onChange(of: searchKey) { newKey in
            if !searchKey.isEmpty {
                dataHandler.advObject = []
                pageNumber = 1
                argsDictionary["keyword"] = newKey
            }
            loadMoreData()
        }
        .navigationBarBackButtonHidden(true)
        
        if isSelectedId != -1 && !dataHandler.advObject.isEmpty {
            NavigationLink("", destination: PostedAdDetailsView(productId: isSelectedId), isActive: $isDetailViewActive)
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
    
    private func loadMoreData() {
        //        guard !dataHandler.isLoading else { return }
        argsDictionary["keyword"] = searchKey
        if !self.searchLocationArray.isEmpty {
            argsDictionary["location"] = searchLocationArray.joined(separator: ",")
        }
        
        if let jsonString = convertToJSONString(argsDictionary ?? [:]) {
            print("filter json", jsonString, searchKey)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dataHandler.getPostedAdvList(request: HomeViewModel.GetAdvRequest.Request(page: pageNumber,userId: self.user_id, isPagination: true, catId: Int(selectedCatId), filterArray: argsDictionary))
            pageNumber+=1
        }
    }
}



struct SearchResultNavigationBar: View {
    var totalCount: Int
    var onBackTap: () -> Void
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        HStack {
            ZStack {
                Image("back")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 15, alignment: .center)
                    .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
            }
            .frame(width: 35, height: 35)
            .onTapGesture { onBackTap() }
            
            HStack(spacing: 10) {
                Text(LocalizedStringKey("Result Found"))
                    .font(.roboto_22_semi())
                    .foregroundColor(Color.black)
                    .padding(.leading, 10)
                Text(String(totalCount))
                    .font(.roboto_22_semi())
                    .foregroundColor(Color.black)
            }
        }
        .padding(.top, 70)
    }
}

struct TagCarousel: View {
    var items: [String]
    
    var body: some View {
        VStack {
            TagsCarouselView(items: items)
        }
        .padding()
    }
}

struct SearchFilterControls: View {
    @Binding var isOpenLocSearchView: Bool
    @Binding var isOpenFilterView: Bool
    var searchLocationArray: [String]
    
    var body: some View {
        HStack {
            Button(action: { isOpenLocSearchView = true }) {
                HStack(spacing: 0) {
                    Image("location_search").padding(.leading, 10)
                    Text(LocalizedStringKey("Search by Location"))
                        .font(.roboto_14())
                        .padding()
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    if !searchLocationArray.isEmpty {
                        Text(String(searchLocationArray.count))
                            .font(.roboto_14())
                            .foregroundColor(.white)
                            .frame(width: 46, height: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 23)
                                    .fill(.black)
                            )
                    }
                }
                .cornerRadius(60)
                .overlay(
                    RoundedRectangle(cornerRadius: 60)
                        .inset(by: -0.5)
                        .stroke(Color(red: 0.94, green: 0.94, blue: 0.94), lineWidth: 1)
                )
            }
            
            Spacer()
            Image(uiImage: UIImage(named: "icn_filter") ?? UIImage())
                .frame(width: 55, height: 55)
                .onTapGesture {
                    isOpenFilterView = true
                }
        }
        .padding(.horizontal, 15)
    }
}

struct PropertyGridView: View {
    var properties: [PropertyData]
    var gridColumns: [GridItem]
    @Binding var isSelectedId: Int
    @Binding var isDetailViewActive: Bool
    var onLastItem: () -> Void
    @StateObject var propertyCardState = PropertyCardState()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(Array(properties.enumerated()), id: \.element.id) { index, property in
                    PropertyCardView( state:propertyCardState, property: property)
                        .onTapGesture {
                            isSelectedId = property.id ?? -1
                            isDetailViewActive = true
                        }
                        .onAppear {
                            if index == properties.count - 1 {
                                onLastItem()
                            }
                        }
                }
            }
            .padding()
        }
    }
}

struct PropertyCardView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    @ObservedObject var state: PropertyCardState
    
    var property: PropertyData
    
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .topLeading) { // Use ZStack for overlapping elements
                KFImage(URL(string: Config.imageBaseUrl + (property.images?.first?.image ?? "")))
                    .placeholder { Image("default_property").resizable().frame(height: 155).cornerRadius(15) }
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.45, height: 155)
                    .scaledToFill()
                    .cornerRadius(15)
                    .padding(.top, 5)

//                // Top left label
//                Text("Top Left") // Replace with your dynamic text
//                    .font(.roboto_10())
//                    .padding(4)
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                    .padding(8)
//
//                // Bottom left label
//                VStack {
//                    Spacer() // Pushes the label to the bottom
//                    Text("Bottom Left") // Replace with your dynamic text
//                        .font(.roboto_10())
//                        .padding(4)
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                       // .padding(.bottom,0)
//                }
//                .padding(8)

                // Button in the top right corner of the image
                VStack {
                    HStack {
                        Spacer() // Pushes button to the right
                        Button {
                            state.selectedType = property.type ?? ""
                            if PersistenceManager.shared.userStates?.currentAuthState == .loggedIn {
                                state.isFavourite.toggle() // Toggle favorite status
                                state.isSelectedId = property.id ?? -1
                                state.isFavClicked = true
                            } else {
                                state.isLoginSheetPresented = true
                            }
                        } label: {
                            Image(property.isFavorite ?? false ? "whish_filled" : "wish")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(0) // Padding around the button for better touch area
                        }
                        .padding(0) // Padding to keep it away from the edge
                    }
                    Spacer() // This spacer allows the button to sit at the top
                }
                .padding(.top, 8) // Adjust as needed to fit design
                .padding(.trailing, 8) // Adjust as needed to fit design
            }

            // Additional content below the image
            Spacer()
            HStack {
                Text(String(format: "%.0f", property.price ?? 0.0))
                    .font(.roboto_18_bold())
                    .foregroundColor(Color.black)
                    .padding(.leading, 8)
                Text("AED")
                    .font(.roboto_16())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
            }
            Text(property.title ?? "")
                .font(.roboto_18_thin())
                .foregroundColor(Color.black)
                .padding([.leading, .trailing], 8)
                .lineLimit(2)
                .frame(maxHeight: 50)
            HStack {
                Image("location_pin").padding([.leading, .bottom], 8)
                Text(property.neighbourhood ?? "")
                    .font(.roboto_14())
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 8)
                Spacer()
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 7, x: 0, y: 4)
        .frame(maxWidth: .infinity) // Allow the card to take full width
    }





    
    
    
}

class PropertyCardState: ObservableObject {
    @Published var isSelectedId: Int = -1
    @Published var selectedType: String = ""
    @Published var isSelected: Bool = false
    @Published var isFavourite: Bool = false
    @Published var isLoginSheetPresented: Bool = false
    @Published var isFavClicked: Bool = false
}
