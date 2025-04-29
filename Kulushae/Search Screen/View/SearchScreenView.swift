//
//  SearchScreenView.swift
//  Kulushae
//
//  Created by ios on 21/02/2024.
//

import SwiftUI

struct SearchScreenView: View {
    @State private var searchText = ""
    @State private var isShowEmptyMessage = false
    @FocusState private var isFocused
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var dataHandler = SearchViewModel.ViewModel()
    @State var isSearchResultOpen: Bool = false
    @State var isCarsResultOpen: Bool = false
    @State var selectedCategory: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image( "back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 12, alignment: .center)
                        .clipped()
                        .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                }
                TextField(LocalizedStringKey("What are you looking?"), text: $searchText)
                    .font(.roboto_16_bold())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .padding()
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                    .focused($isFocused)
                
                if isFocused {
                    Button(action: {
                        self.isFocused = false
                        self.searchText = ""
                        // Dismiss keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(.trailing, 8)
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            ScrollView {
                if(dataHandler.searchObjectList.isEmpty && isShowEmptyMessage) {
                    Text(LocalizedStringKey("No item found"))
                                       .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                       .padding()
                                       .font(.roboto_20())
                                       .font(.headline.weight(.semibold))
                                       .multilineTextAlignment(.leading)
                                       .foregroundColor(Color.black)
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(dataHandler.searchObjectList, id: \.self) { item in
                            HStack{
                                VStack {
                                    Text(item.propertyTitle ?? searchText)
                                        .font(.roboto_14_Medium())
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 1)
                                    Text(LocalizedStringKey(item.category ?? ""))
                                        .font(.roboto_14())
                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Spacer()
                                Text(String(item.ads ?? 0))
                                    .font(.roboto_14())
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.iconSelectionColor)
                                    .cornerRadius(10)
                                    .clipped()
                            }
                            .onTapGesture() {
                                selectedCategory = String(item.categoryID ?? -1)
                                if let type = item.type,
                                   type.lowercased().contains("motor"){
                                    isCarsResultOpen = true
                                } else {
                                    isSearchResultOpen = true
                                }
                                
                            }
                        }
                    }
                }
               
            }
            .padding(.horizontal, 15)
        }
        .background(.white)
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
               isFocused = true
            }
        }
        .onChange(of: searchText) { newKey in
            dataHandler.getSearResults(request: SearchViewModel.GetProductDetailsRequest.Request(value: newKey, serviceType: ""))
            if(dataHandler.searchObjectList.isEmpty) {
                isShowEmptyMessage = true
            }
        }
        NavigationLink("", destination: SearchResultView(searchKey: searchText, selectedCatId: selectedCategory),
                       isActive: $isSearchResultOpen)
        
//        NavigationLink("", destination: CarsSearchResultView(searchKey: searchText, selectedCatId: selectedCategory),
//                       isActive: $isCarsResultOpen)
        NavigationLink("", destination: CarListScreenView(dataHandler: .init(categoryId: selectedCategory, search: searchText, userId: nil)),
                       isActive: $isCarsResultOpen)
    }
    
}
