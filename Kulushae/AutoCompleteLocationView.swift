//
//  AutoCompleteLocationView.swift
//  Kulushae
//
//  Created by ios on 10/11/2023.
//

import SwiftUI

struct AddressAutocompleteView: View {
    @State var title: String = ""
    @State private var searchQuery: String = ""
    @StateObject private var searchDelegate = SearchDelegate()
    @EnvironmentObject var languageManager: LanguageManager
    var body: some View {

        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 1) {
                // Placeholder
                Text(LocalizedStringKey(title))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .background(.white)
                    .offset(y:  -15)
            }
        }
        .font(.roboto_16())
        .frame(height: 50, alignment: .center)
        .onAppear {
            searchDelegate.searchAddress(query: searchQuery)
        }
        
        Spacer()
        
        List(searchDelegate.searchResults, id: \.id) { result in
            Text(LocalizedStringKey(result.name))
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .frame( height: 40)
                .foregroundColor(.black)
                .onTapGesture {
                    print("Selected address: \(result.name)")
                }
        }
        .listStyle(PlainListStyle())
    }
}
