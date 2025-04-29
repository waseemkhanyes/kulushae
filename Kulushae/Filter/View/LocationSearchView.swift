//
//  LocationSearchView.swift
//  Kulushae
//
//  Created by ios on 14/02/2024.
//

import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var searchDelegate = SearchDelegate()
    @State private var isSearchSheetOpen: Bool = false
    @State private var selectedPlace: String = ""
    @Binding var isOpen: Bool
    @Binding var selectedLocationArray : [String]
    
    var body: some View {
        
        VStack {
            HStack {
                Text(LocalizedStringKey("Clear"))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .onTapGesture {
                        selectedLocationArray = []
                    }
                Spacer()
                Text(LocalizedStringKey("Exclude Locations"))
                    .font(.roboto_16_bold())
                    .fontWeight(.bold)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .onTapGesture {
                        selectedLocationArray = []
                    }
                Spacer()
                Text(LocalizedStringKey("Close"))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .onTapGesture() {
                        isOpen.toggle()
                    }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
            .padding(.top, 15)
            
            KulushaeActionFields(placeholder: "",
                                 fieldType: .map_searchable,
                                 imageName: "location_pin",
                                 selectedDate: $selectedPlace,
                                 items: [],
                                 textValue: self.selectedPlace ,
                                 textViewTitle: "",
                                 isEnableExtraTitle:  false ,
                                 isDatePickerShowing: .constant(false),
                                 index: 0,
                                 didGetValue: { index, actionValue, _ , _ in
                searchDelegate.searchAddress(query: actionValue)
                
            })
            .padding()
            .keyboardType(.default)
            .onTapGesture(){
                DispatchQueue.main.async {
                    isSearchSheetOpen = true
                }
            }
            if(isSearchSheetOpen && !searchDelegate.searchResults.isEmpty) {
                ScrollView {
                    VStack {
                        ForEach(searchDelegate.searchResults, id: \.id) { result in
                            Button(action: {
                                selectedPlace =  result.name
                                selectedLocationArray.append(result.name)
                                self.selectedPlace = ""
                               
                            }) {
                                VStack {
                                    Text(result.name)
                                        .font(.roboto_14())
                                        .foregroundColor(.black)
                                        .frame(height: 35, alignment: .leading)
                                    Divider()
                                        .frame(height: 1)
                                        .padding(.horizontal, 30)
                                        .background(Color.unselectedBorderColor)
                                }

                            }
                            .frame(maxHeight: .screenWidth * 0.9)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 35, maxHeight: .infinity)// Set a maximum height for the ScrollView if needed
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .padding(.top, -10)
                
            }
            ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(selectedLocationArray, id: \.self) { item in
                            HStack {
                                HStack(alignment: .center, spacing: 0) {
                                    Text(LocalizedStringKey(item))
                                        .font(.roboto_14())
                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                        .padding(.leading, 3)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    ZStack {
                                        Color.clear
                                            .frame(width: 30, height: 30)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                if let indexToRemove = selectedLocationArray.firstIndex(of: item) {
                                                    selectedLocationArray.remove(at: indexToRemove)
                                                }
                                            }
                                        
                                        Image(uiImage: UIImage(named: "close") ?? UIImage())
                                            .resizable()
                                            .frame(width: 14, height: 14) // Adjust this to set the image size.
                                            .foregroundColor(.white)
                                    }
                                }
                                .background(Color.iconSelectionColor)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.clear )
                                )
                            }
                            
                        }
                    }
                    .padding(.horizontal, 15)
                    //                                                    .onChange(of: selectedAmenityIDs) { newValue in
                    //                                                        DispatchQueue.main.async {
                    //                                                            dataHandler.formData[indexVal][index].fieldValue = selectedAmenityIDs.joined(separator: ",")
                    //                                                        }
                    //                                                    }
                
            }
           
            Spacer()
        }
    }
}

