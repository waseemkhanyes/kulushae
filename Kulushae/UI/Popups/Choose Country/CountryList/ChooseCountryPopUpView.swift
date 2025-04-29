//
//  ChooseCountryPopUpView.swift
//  Kulushae
//
//  Created by waseem on 03/12/2024.
//

import SwiftUI

struct ChooseCountryPopUpView: View {

    @StateObject var viewModel = ChooseCountryScreenViewModel.ViewModel(selectedCountryWithState: nil)
    @EnvironmentObject var languageManager: LanguageManager
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        UILoader(isShowing: viewModel.isLoading) {
            ZStack(alignment: .bottom) {
                Color.clear
                
                VStack(spacing: 0) {
                    HeaderTitleAndDismiss
                    
                    searchView
                    
                    scrollContent
                }
                .background(
                    Color.white
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .shadow(color: .black.opacity(0.05), radius: 16, x: 0, y: -1)
                )
            }
        }
        .padding(.top, 119)
        .environment(\.layoutDirection, languageManager.layoutDirection)
        .cleanNavigation()
    }
    
    var HeaderTitleAndDismiss: some View {
        HStack(spacing: 0) {
            Text(LocalizedStringKey("Choose Country"))
                .textStyle(font: .Roboto.Regular(of: 22))
                .fontWeight(.bold)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Image(.close)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(hex: 0x33363F))
                    .padding(10)
            }
        }
        .padding(.top, 20)
        .padding(.leading, 18)
        .padding(.trailing, 8)
    }
    
    var searchView: some View {
        HStack(spacing: 6) {
            Image(.imgSearch)
                .resizable()
                .frame(width: 24, height: 24)
            
            TextField(LocalizedStringKey("Search Country"), text: $viewModel.searchCountry)
                .textStyle(font: .Roboto.Regular(of: 16))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .onChange(of: viewModel.searchCountry) { text in
                    viewModel.filterCountry(text: text)
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 9)
        .background(
            Color.white
                .border(Color(hex: 0xF0F0F0), width: 1, cornerRadius: 22)
        )
        .focused($isTextFieldFocused)
        .onTapGesture {
            isTextFieldFocused = true
        }
        .padding(.horizontal, 18)
    }
    
    var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                selectedView
                
                countrylistItemView(viewModel.arrayCountries)
                    .padding(.bottom, 40)
//                characterSectionListView
            }
        }
    }
    
    @ViewBuilder
    var selectedView: some View {
        if let country = viewModel.selectedCountryWithState?.country {
            VStack(alignment: .leading, spacing: 0) {
                
                Text(LocalizedStringKey("Selected"))
                    .textStyle(font: Font.Roboto.Regular(of: 16), color: Color(hex: 0x000000))
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 50)
                    .padding(.leading, 27)
                    .padding(.top, 10)
                    
                
                countryItemView(country)
            }
        }
    }
    
    func countrylistItemView(_ countries: [KulushaeCountry]) -> some View {
        VStack(spacing: 0) {
            Text(LocalizedStringKey("All"))
                .textStyle(font: Font.Roboto.Regular(of: 16), color: Color(hex: 0x000000))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 50)
                .padding(.leading, 27)
                .padding(.top, 10)
            
            ForEach(countries, id: \.self) { country in
                countryItemView(country)
            }
        }
    }
    
    func countryItemView(_ country: KulushaeCountry) -> some View {
        return Button(action: {
            viewModel.onClickCountry(country)
        }) {
            HStack(spacing: 0) {
                let isSelected = viewModel.selectedCountryWithState?.country.id ?? 0 == country.id
                Text("\(trim(country.emoji)) \(trim(country.name))")
                    .textStyle(font: .Roboto.Regular(of: 14), color: Color(hex: isSelected ? 0xFE820E : 0x000000))
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .fontWeight(.bold)
                    .padding(.leading, 27)
                
                Spacer()
                
                if isSelected {
                    Image(.tick)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: 0x79A7C9))
                        .padding(.trailing, 38)
                }
            }
            .frame(height: 40)
        }
    }
}

//#Preview {
//    ChooseCountryPopUpView()
//        .background(
//            Color.orange
//                .ignoresSafeArea()
//        )
//}
