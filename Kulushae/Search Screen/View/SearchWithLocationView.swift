//
//  SearchWithLocationView.swift
//  Kulushae
//
//  Created by ios on 12/05/2024.
//

import Foundation
import SwiftUI
import MapKit

class LocationSearchHandler: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    let completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}

struct SearchWithLocationView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var searchText: String = ""
    @State private var searchCompleter = MKLocalSearchCompleter()
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @Binding var isOpen: Bool
    @Binding var selectedLocationArray: [String]
    @ObservedObject private var searchHandler = LocationSearchHandler()
    @State var title: String
    @FocusState private var isFocused
    
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
                Text(LocalizedStringKey(title))
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
                    .onTapGesture {
                        isOpen.toggle()
                    }
            }
            .padding([.horizontal, .bottom, .top], 15)
            HStack(spacing: 0) {
                Image("location_search")
                    .padding(.leading, 10)
                TextField(LocalizedStringKey("Search by Location"), text: $searchText)
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .padding()
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                    .onChange(of: searchText) { newValue in
                        searchHandler.completer.queryFragment = newValue
                    }
//                    .focused($isFocused)
                Spacer()
                
            }
            .cornerRadius(60)
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .inset(by: -0.5)
                    .stroke(Color(red: 0.94, green: 0.94, blue: 0.94), lineWidth: 1)
            )
            .padding(.horizontal, 15)
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(selectedLocationArray, id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(.roboto_14())
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    if let indexToRemove = selectedLocationArray.firstIndex(of: item) {
                                        selectedLocationArray.remove(at: indexToRemove)
                                    }
                                }
                                .padding(.trailing, 10)
                        }
                        .frame(height: 40)
                        .background(  Color.appPrimaryColor )
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(  Color.clear ))
                    }
                }
                .padding(.horizontal, 15)
            }
            
            List(searchHandler.searchResults, id: \.title) { result in
                Button(action: {
                    selectedLocationArray.append(result.title)
                    searchText = ""
                }) {
                    Text(result.title)
                        .font(.roboto_14())
                }
            }
            .listStyle(PlainListStyle())
            
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
               isFocused = true
            }
        }
        
    }
}

